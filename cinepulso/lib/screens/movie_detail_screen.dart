import 'package:flutter/material.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/screens/video_player_screen.dart';
import 'package:cinepulso/theme.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar with movie poster background
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: GSFilmsColors.richBlack,
            iconTheme: const IconThemeData(color: GSFilmsColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Backdrop image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movie.posterUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          GSFilmsColors.black.withValues(alpha: 0.3),
                          GSFilmsColors.black.withValues(alpha: 0.7),
                          GSFilmsColors.black,
                        ],
                      ),
                    ),
                  ),
                  // Play button
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _playMovie(context),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: GSFilmsColors.neonGold.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: GSFilmsColors.neonGold.withValues(alpha: 0.5),
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Movie details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: GSFilmsColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Movie info row
                  Row(
                    children: [
                      // Genre
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GSFilmsColors.neonGold.withValues(alpha: 0.2),
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
                      
                      // Duration
                      const Icon(Icons.access_time, color: GSFilmsColors.lightGray, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.duration,
                        style: const TextStyle(color: GSFilmsColors.lightGray),
                      ),
                      
                      const Spacer(),
                      
                      // Views
                      if (movie.views > 0) ...[
                        const Icon(Icons.visibility, color: GSFilmsColors.lightGray, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '\${_formatViews(movie.views)} vistas',
                          style: const TextStyle(color: GSFilmsColors.lightGray),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Synopsis
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
                  
                  // Play button
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GSFilmsColors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Additional info
                  if (movie.audioTracks != null && movie.audioTracks!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Pistas de audio',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: GSFilmsColors.neonGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.audioTracks!.map((track) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: GSFilmsColors.charcoal,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: GSFilmsColors.mediumGray),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.audiotrack, color: GSFilmsColors.neonGold, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                track,
                                style: const TextStyle(color: GSFilmsColors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  if (movie.subtitleUrl != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: GSFilmsColors.charcoal.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: GSFilmsColors.mediumGray),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.subtitles, color: GSFilmsColors.neonGold),
                          SizedBox(width: 12),
                          Text(
                            'Subtítulos disponibles',
                            style: TextStyle(
                              color: GSFilmsColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
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
      return '\${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '\${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}