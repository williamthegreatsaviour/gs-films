import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/screens/movie_detail_screen.dart';
import 'package:cinepulso/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final MovieProvider _movieProvider;

  @override
  void initState() {
    super.initState();
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _movieProvider.loadMovies(); // Asegúrate de que carga las películas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      appBar: AppBar(
        title: const Text('GSFilms'),
        backgroundColor: GSFilmsColors.richBlack,
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: GSFilmsColors.neonGold,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: provider.movies.length,
              itemBuilder: (context, index) {
                final movie = provider.movies[index];
                return MoviePosterAnimated(movie: movie, index: index);
              },
            ),
          );
        },
      ),
    );
  }
}

class MoviePosterAnimated extends StatefulWidget {
  final Movie movie;
  final int index;

  const MoviePosterAnimated({super.key, required this.movie, required this.index});

  @override
  State<MoviePosterAnimated> createState() => _MoviePosterAnimatedState();
}

class _MoviePosterAnimatedState extends State<MoviePosterAnimated> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Delay escalonado por índice
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: widget.movie),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.movie.posterUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: GSFilmsColors.charcoal,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: GSFilmsColors.neonGold,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: GSFilmsColors.charcoal,
                      child: const Center(
                        child: Icon(Icons.movie,
                            color: GSFilmsColors.mediumGray, size: 40),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GSFilmsColors.black.withOpacity(0.0),
                          GSFilmsColors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      widget.movie.title,
                      style: const TextStyle(
                        color: GSFilmsColors.neonGold,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
