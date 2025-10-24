import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/screens/video_player_screen.dart';
import 'package:cinepulso/theme.dart';
import 'package:cinepulso/providers/movie_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      body: CustomScrollView(
        slivers: [
          // AppBar con poster animado
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: GSFilmsColors.richBlack,
            iconTheme: const IconThemeData(color: GSFilmsColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Poster con animación de fade-in
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(movie.posterUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          GSFilmsColors.black.withOpacity(0.3),
                          GSFilmsColors.black.withOpacity(0.7),
                          GSFilmsColors.black,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            movie.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: GSFilmsColors.red,
                            size: 28,
                          ),
                          onPressed: () async {
                            final updatedMovie =
                                await movieProvider.toggleLike(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(updatedMovie.isLiked
                                    ? 'Añadido a favoritos'
                                    : 'Quitado de favoritos'),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            movie.inWatchlist
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: GSFilmsColors.neonGold,
                            size: 28,
                          ),
                          onPressed: () async {
                            final updatedMovie =
                                await movieProvider.toggleWatchlist(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(updatedMovie.inWatchlist
                                    ? 'Añadido a Mi Lista'
                                    : 'Quitado de Mi Lista'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Botón de reproducción animado
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _playMovie(context),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 1),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: GSFilmsColors.neonGold.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: GSFilmsColors.neonGold.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: GSFilmsColors.black,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: GSFilmsColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GSFilmsColors.neonGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GSFilmsColors.neonGold),
                        ),
                        child: Text(
                          movie.genre,
                          style: const TextStyle(
                            color: GSFilmsColors.neonGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          color: GSFilmsColors.lightGray, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.duration,
                        style: const TextStyle(color: GSFilmsColors.lightGray),
                      ),
                      const Spacer(),
                      if (movie.views > 0) ...[
                        const Icon(Icons.visibility,
                            color: GSFilmsColors.lightGray, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatViews(movie.views)} vistas',
                          style:
                              const TextStyle(color: GSFilmsColors.lightGray),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sinopsis',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: GSFilmsColors.neonGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.synopsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: GSFilmsColors.white,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _playMovie(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GSFilmsColors.neonGold,
                        foregroundColor: GSFilmsColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 28),
                      label: Text(
                        'Reproducir',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GSFilmsColors.black,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playMovie(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(movie: movie),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}
