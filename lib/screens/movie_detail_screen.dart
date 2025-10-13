import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import 'player_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});
  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _service = MovieService();
  MovieModel? movie;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    int id = 0;
    if (arg is int) id = arg;
    else if (arg is Map && arg['id'] != null) id = arg['id'];
    if (id > 0) _load(id);
  }

  Future<void> _load(int id) async {
    setState(() => loading = true);
    try {
      final data = await _service.getMovieDetails(id);
      setState(() {
        movie = MovieModel.fromJson(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al cargar la película')));
    }
  }

  Future<void> _toggleFav() async {
    if (movie == null) return;
    final ok = await _service.toggleFavorite(movie!.id);
    if (ok) setState(() => movie = MovieModel.fromJson({... (movieAsMap()), 'is_favorite': !movie!.isFavorite}));
  }

  Future<void> _toggleWatch() async {
    if (movie == null) return;
    final ok = await _service.toggleWatchlist(movie!.id);
    if (ok) setState(() => movie = MovieModel.fromJson({... (movieAsMap()), 'in_watchlist': !movie!.inWatchlist}));
  }

  Map<String, dynamic> movieAsMap() {
    if (movie == null) return {};
    return {
      'id': movie!.id,
      'title': movie!.title,
      'description': movie!.description,
      'poster': movie!.poster,
      'files': movie!.files,
      'subtitles': movie!.subtitles,
      'cast': movie!.cast,
      'is_favorite': movie!.isFavorite,
      'in_watchlist': movie!.inWatchlist,
    };
  }

  void _play() {
    if (movie == null) return;
    final files = movie!.files ?? [];
    String? url;
    if (files.isNotEmpty) {
      // prefer HLS or first file
      final f = files.first;
      url = f['file_path'] ?? f['url'] ?? f['file'] ?? f['stream_url'];
    }
    if (url != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(videoUrl: url, subtitles: movie!.subtitles)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se encontró URL de reproducción')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))));
    if (movie == null) return const Scaffold(body: Center(child: Text('Película no encontrada')));

    return Scaffold(
      appBar: AppBar(title: Text(movie!.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie!.poster != null ? Image.network(movie!.poster!, fit: BoxFit.cover) : Container(height:220,color:Colors.grey),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(movie!.description),
                  const SizedBox(height: 12),
                  Row(children: [
                    ElevatedButton.icon(onPressed: _play, icon: const Icon(Icons.play_arrow, color: Colors.black), label: const Text('Reproducir', style: TextStyle(color: Colors.black)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700))),
                    const SizedBox(width: 12),
                    IconButton(onPressed: _toggleFav, icon: Icon(movie!.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent)),
                    IconButton(onPressed: _toggleWatch, icon: Icon(movie!.inWatchlist ? Icons.bookmark : Icons.bookmark_border)),
                  ]),
                  const SizedBox(height: 16),
                  if ((movie!.cast ?? []).isNotEmpty) ...[
                    const Text('Elenco', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(height: 110, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: movie!.cast!.length, itemBuilder: (ctx,i){
                      final c = movie!.cast![i];
                      return Container(width:80, margin: const EdgeInsets.only(right:8), child: Column(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(c['photo'] ?? '', width:70, height:70, fit: BoxFit.cover, errorBuilder:(_,__,___)=>Container(width:70,height:70,color:Colors.grey))),
                        const SizedBox(height:6),
                        Text(c['name'] ?? '', maxLines:2, textAlign: TextAlign.center),
                      ]));
                    })),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
