import 'package:flutter/foundation.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/api_service.dart';

class MovieProvider with ChangeNotifier {
  List<MovieGenre> _moviesByGenre = [];
  List<Movie> _rentedMovies = [];
  List<Movie> _top10Movies = [];
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  List<MovieGenre> get moviesByGenre => _moviesByGenre;
  List<Movie> get rentedMovies => _rentedMovies;
  List<Movie> get top10Movies => _top10Movies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMoviesByGenre() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _moviesByGenre = await ApiService.getMoviesByGenre();
    } catch (e) {
      _error = 'Error cargando películas';
      print('Error loading movies by genre: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRentedMovies(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rentedMovies = await ApiService.getRentedMovies(userId);
    } catch (e) {
      _error = 'Error cargando películas rentadas';
      print('Error loading rented movies: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTop10Movies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _top10Movies = await ApiService.getTop10Movies();
    } catch (e) {
      _error = 'Error cargando top 10';
      print('Error loading top 10 movies: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await ApiService.searchMovies(query);
    } catch (e) {
      _error = 'Error en la búsqueda';
      print('Error searching movies: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Movie? getMovieById(String id) {
    // Buscar en todas las listas de películas
    for (var genre in _moviesByGenre) {
      for (var movie in genre.movies) {
        if (movie.id == id) return movie;
      }
    }
    
    for (var movie in _rentedMovies) {
      if (movie.id == id) return movie;
    }
    
    for (var movie in _top10Movies) {
      if (movie.id == id) return movie;
    }
    
    for (var movie in _searchResults) {
      if (movie.id == id) return movie;
    }
    
    return null;
  }
}