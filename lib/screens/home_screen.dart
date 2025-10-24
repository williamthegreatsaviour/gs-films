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

class _HomeScreenState extends State<HomeScreen> {
  late final MovieProvider _movieProvider;

  @override
  void initState() {
    super.initState();
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _movieProvider.loadMovies();
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

          // Divide movies en filas de 2
          final List<List<Movie>> rows = [];
          for (int i = 0; i < provider.movies.length; i += 2) {
            rows.add(provider.movies.sublist(
                i,
                i + 2 > provider.movies.length
                    ? provider.movies.length
                    : i + 2));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) {
              final rowMovies = rows[rowIndex];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rowMovies
                    .asMap()
                    .entries
                    .map((entry) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: entry.key == 0 && rowMovies.length > 1
                                    ? 6
                                    : 0,
                                left: entry.key == 1 ? 6 : 0),
                            child: MoviePosterOnScroll(
                              movie: entry.value,
                              rowIndex: rowIndex,
                              index: entry.key,
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}

class MoviePosterOnScroll extends StatefulWidget {
  final Movie movie;
  final int rowIndex;
  final int index;

  const MoviePosterOnScroll({
    super.key,
    required this.movie,
    required this.rowIndex,
    required this.index,
  });

  @override
  State<MoviePosterOnScroll> createState() => _MoviePosterOnScrollState();
}

class _MoviePosterOnScrollState extends State<MoviePosterOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isVisible = false;

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
  }

  void _triggerAnimation() {
    if (!_isVisible) {
      _isVisible = true;
      Future.delayed(Duration(
          milliseconds: (widget.rowIndex * 2 + widget.index) * 150), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final position = renderBox.localToGlobal(Offset.zero).dy;
            final screenHeight = MediaQuery.of(context).size.height;
            if (position < screenHeight) {
              _triggerAnimation();
            }
          }
        });

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
      },
    );
  }
}
