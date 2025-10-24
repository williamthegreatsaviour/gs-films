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
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: GSFilmsColors.richBlack,
            iconTheme: const IconThemeData(color: GSFilmsColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder.png',
                    image: movie.posterUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
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
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _playMovie(context),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: GSFilmsColors.neonGold.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: GSFilmsColors.neonGold.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)],
                          ),
                          child: const Icon(Icons.play_arrow, color: GSFilmsColors.black, size: 40),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: GSFilmsColors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(movie.synopsis, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: GSFilmsColors.white, height: 1.6)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _playMovie(context),
                      icon: const Icon(Icons.play_arrow, size: 28),
                      label: const Text('Reproducir', style: TextStyle(fontWeight: FontWeight.bold, color: GSFilmsColors.black)),
                      style: ElevatedButton.styleFrom(backgroundColor: GSFilmsColors.neonGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playMovie(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => VideoPlayerScreen(movie: movie)));
  }
}
