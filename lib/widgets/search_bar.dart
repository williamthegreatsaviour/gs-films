import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/screens/movie_detail_screen.dart';
import 'package:cinepulso/theme.dart';

class MovieSearchBar extends StatefulWidget {
  const MovieSearchBar({super.key});

  @override
  State<MovieSearchBar> createState() => _MovieSearchBarState();
}

class _MovieSearchBarState extends State<MovieSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (query.isEmpty) {
      setState(() {
        _isSearchActive = false;
      });
      movieProvider.clearSearchResults();
    } else {
      setState(() {
        _isSearchActive = true;
      });
      movieProvider.searchMovies(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.clearSearchResults();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Input
        Container(
          decoration: BoxDecoration(
            color: GSFilmsColors.charcoal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isSearchActive ? GSFilmsColors.neonGold : GSFilmsColors.mediumGray,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: GSFilmsColors.white),
            decoration: InputDecoration(
              hintText: 'Buscar películas...',
              hintStyle: const TextStyle(color: GSFilmsColors.lightGray),
              prefixIcon: const Icon(Icons.search, color: GSFilmsColors.neonGold),
              suffixIcon: _isSearchActive
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: GSFilmsColors.lightGray),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        
        // Search Results
        if (_isSearchActive)
          Consumer<MovieProvider>(
            builder: (context, movieProvider, child) {
              if (movieProvider.isLoading) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GSFilmsColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(GSFilmsColors.neonGold),
                    ),
                  ),
                );
              }

              if (movieProvider.searchResults.isEmpty && _searchController.text.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GSFilmsColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_off, color: GSFilmsColors.lightGray),
                      SizedBox(width: 8),
                      Text(
                        'No se encontraron resultados',
                        style: TextStyle(color: GSFilmsColors.lightGray),
                      ),
                    ],
                  ),
                );
              }

              if (movieProvider.searchResults.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: GSFilmsColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GSFilmsColors.mediumGray),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: movieProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.searchResults[index];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: GSFilmsColors.neonGold),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: GSFilmsColors.mediumGray,
                                  child: const Icon(
                                    Icons.movie,
                                    color: GSFilmsColors.lightGray,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            color: GSFilmsColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '\${movie.genre} • \${movie.duration}',
                          style: const TextStyle(color: GSFilmsColors.lightGray),
                        ),
                        trailing: const Icon(
                          Icons.play_arrow,
                          color: GSFilmsColors.neonGold,
                        ),
                        onTap: () {
                          _clearSearch();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}