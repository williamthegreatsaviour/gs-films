import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _service = MovieService();
  List<dynamic> _movies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await _service.getDashboard();
      // posible estructura: data['movies'] o data['data']['movies']
      final movies = data['movies'] ?? data['data'] ?? [];
      setState(() {
        _movies = movies as List<dynamic>;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error cargando datos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GSFilms'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: ()=>Navigator.pushNamed(context, '/profile')),
        ],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)))
        : RefreshIndicator(
            onRefresh: _load,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: _movies.length,
              itemBuilder: (context, i) {
                final m = _movies[i];
                return MovieCard(movie: m);
              },
            ),
          ),
    );
  }
}
