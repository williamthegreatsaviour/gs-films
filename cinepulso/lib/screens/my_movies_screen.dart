import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/providers/auth_provider.dart';
import 'package:cinepulso/screens/movie_detail_screen.dart';
import 'package:cinepulso/widgets/movie_card.dart';
import 'package:cinepulso/theme.dart';

class MyMoviesScreen extends StatefulWidget {
  const MyMoviesScreen({super.key});

  @override
  State<MyMoviesScreen> createState() => _MyMoviesScreenState();
}

class _MyMoviesScreenState extends State<MyMoviesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (authProvider.user != null) {
        movieProvider.loadRentedMovies(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      appBar: AppBar(
        backgroundColor: GSFilmsColors.richBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GSFilmsColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mis Películas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: GSFilmsColors.neonGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading && movieProvider.rentedMovies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(GSFilmsColors.neonGold),
              ),
            );
          }

          if (movieProvider.rentedMovies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_library_outlined,
                    size: 80,
                    color: GSFilmsColors.lightGray,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No tienes películas rentadas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: GSFilmsColors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Para rentar nuevas películas visita la web oficial de GSFilms',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GSFilmsColors.lightGray,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: GSFilmsColors.neonGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GSFilmsColors.neonGold),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: GSFilmsColors.neonGold,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aviso Importante',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: GSFilmsColors.neonGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Para rentar nuevas películas visita la web oficial de GSFilms',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GSFilmsColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with count
                Row(
                  children: [
                    Text(
                      'Películas Rentadas',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: GSFilmsColors.neonGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: GSFilmsColors.neonGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\${movieProvider.rentedMovies.length}',
                        style: const TextStyle(
                          color: GSFilmsColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Movies Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: movieProvider.rentedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = movieProvider.rentedMovies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Notice about renting new movies
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GSFilmsColors.charcoal.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GSFilmsColors.mediumGray),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: GSFilmsColors.neonGold,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Para rentar nuevas películas visita la web oficial',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: GSFilmsColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}