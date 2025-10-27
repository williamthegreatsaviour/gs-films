import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/screens/video_player_screen.dart';
import 'package:cinepulso/theme.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie movie;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: GSFilmsColors.charcoal),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  movie.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: movie.isLiked ? GSFilmsColors.red : GSFilmsColors.white,
                ),
                onPressed: () async {
                  try {
                    final updatedMovie = await movieProvider.toggleLike(movie.id);
                    setState(() {
                      movie = updatedMovie;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar like')),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  movie.inWatchlist ? Icons.playlist_add_check : Icons.playlist_add,
                  color: movie.inWatchlist ? GSFilmsColors.success : GSFilmsColors.white,
                ),
                onPressed: () async {
                  try {
                    final updatedMovie = await movieProvider.toggleWatchlist(movie.id);
                    setState(() {
                      movie = updatedMovie;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar Mi Lista')),
                    );
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: GSFilmsColors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${movie.genre} • ${movie.duration}',
                    style: TextStyle(
                      color: GSFilmsColors.lightGray,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sinopsis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: GSFilmsColors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.synopsis,
                    style: TextStyle(
                      color: GSFilmsColors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(movie: movie),
                          ),
                        );
                      },
                      child: const Text('Ver película'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Opcional: para depuración
                  Text(
                    'isLiked: ${movie.isLiked}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    'inWatchlist: ${movie.inWatchlist}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    'lastWatchedPosition: ${movie.lastWatchedPosition ?? "null"}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
