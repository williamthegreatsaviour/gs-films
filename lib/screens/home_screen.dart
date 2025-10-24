import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/providers/auth_provider.dart';
import 'package:cinepulso/screens/my_movies_screen.dart';
import 'package:cinepulso/screens/movie_detail_screen.dart';
import 'package:cinepulso/screens/login_screen.dart';
import 'package:cinepulso/widgets/movie_card.dart';
import 'package:cinepulso/widgets/search_bar.dart';
import 'package:cinepulso/theme.dart';
import 'package:cinepulso/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      await movieProvider.loadMoviesByGenre();
      await movieProvider.loadTop10Movies();
      await movieProvider.loadContinueWatching();
      await movieProvider.loadWatchlist();
    });
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _navigateToMyMovies() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MyMoviesScreen()),
    );
  }

  void _navigateToMovieDetail(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      appBar: AppBar(
        backgroundColor: GSFilmsColors.richBlack,
        title: Row(
          children: [
            const Icon(Icons.movie, color: GSFilmsColors.neonGold),
            const SizedBox(width: 8),
            Text(
              'GSFilms',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: GSFilmsColors.neonGold,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_library, color: GSFilmsColors.neonGold),
            onPressed: _navigateToMyMovies,
            tooltip: 'Mis Películas',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: GSFilmsColors.white),
            color: GSFilmsColors.charcoal,
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: GSFilmsColors.error),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión',
                        style: TextStyle(color: GSFilmsColors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading &&
              movieProvider.moviesByGenre.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(GSFilmsColors.neonGold),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await movieProvider.loadMoviesByGenre();
              await movieProvider.loadTop10Movies();
              await movieProvider.loadContinueWatching();
              await movieProvider.loadWatchlist();
            },
            color: GSFilmsColors.neonGold,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: MovieSearchBar(),
                  ),

                  // 🔁 Continue Watching Section
                  if (movieProvider.continueWatching.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Seguir Viendo',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: GSFilmsColors.neonGold,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: movieProvider.continueWatching.length,
                        itemBuilder: (context, index) {
                          final movie = movieProvider.continueWatching[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MovieCard(
                              movie: movie,
                              onTap: () => _navigateToMovieDetail(movie),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // ⭐ Watchlist Section
                  if (movieProvider.watchlist.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Mi Lista',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: GSFilmsColors.neonGold,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: movieProvider.watchlist.length,
                        itemBuilder: (context, index) {
                          final movie = movieProvider.watchlist[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MovieCard(
                              movie: movie,
                              onTap: () => _navigateToMovieDetail(movie),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 🔝 Top 10
                  if (movieProvider.top10Movies.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Top 10 Más Vistas',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: GSFilmsColors.neonGold,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: movieProvider.top10Movies.length,
                        itemBuilder: (context, index) {
                          final movie = movieProvider.top10Movies[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MovieCard(
                              movie: movie,
                              showRank: true,
                              rank: index + 1,
                              onTap: () => _navigateToMovieDetail(movie),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 🎬 Movies by Genre
                  ...movieProvider.moviesByGenre.map((genre) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            genre.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: GSFilmsColors.neonGold,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: genre.movies.length,
                            itemBuilder: (context, index) {
                              final movie = genre.movies[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: MovieCard(
                                  movie: movie,
                                  onTap: () =>
                                      _navigateToMovieDetail(movie),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  }).toList(),

                  if (movieProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: GSFilmsColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GSFilmsColors.error),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error,
                                color: GSFilmsColors.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                movieProvider.error!,
                                style: const TextStyle(
                                    color: GSFilmsColors.error),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                movieProvider.clearError();
                                movieProvider.loadMoviesByGenre();
                                movieProvider.loadTop10Movies();
                                movieProvider.loadContinueWatching();
                                movieProvider.loadWatchlist();
                              },
                              child: const Text(
                                'Reintentar',
                                style: TextStyle(
                                    color: GSFilmsColors.neonGold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
