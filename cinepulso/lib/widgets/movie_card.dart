import 'package:flutter/material.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/theme.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final bool showRank;
  final int? rank;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.showRank = false,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: GSFilmsColors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GSFilmsColors.neonGold,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie.posterUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: GSFilmsColors.charcoal,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 40,
                                color: GSFilmsColors.mediumGray,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sin imagen',
                                style: TextStyle(
                                  color: GSFilmsColors.mediumGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Rank Badge (for Top 10)
                  if (showRank && rank != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: GSFilmsColors.neonGold,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: GSFilmsColors.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '#\$rank',
                          style: const TextStyle(
                            color: GSFilmsColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Play button overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            GSFilmsColors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: GSFilmsColors.neonGold,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Movie Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: GSFilmsColors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Movie Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      movie.genre,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GSFilmsColors.lightGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (movie.views > 0) ...[
                    const Icon(
                      Icons.visibility,
                      size: 12,
                      color: GSFilmsColors.lightGray,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _formatViews(movie.views),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GSFilmsColors.lightGray,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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