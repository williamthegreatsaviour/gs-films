import 'package:flutter/foundation.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/api_service.dart';

class MovieProvider with ChangeNotifier {
  List<MovieGenre> _moviesByGenre = [];
  List<Movie> _rentedMovies = [];
  List<Movie> _top10Movies = [];
  List<Movie> _searchResults = [];
  List<Movie> _continueWatching = [];
  List<Movie> _watchlist = [];

  bool _isLoading = false;
  String? _error;

  // ===== GETTERS =====
  List<MovieGenre> get moviesByGenre => _moviesByGenre;
  List<Movie> get rentedMovies => _rentedMovies;
  List<Movie> get top10Movies => _top10Movies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get continueWatching => _continueWatching;
  List<Movie> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ===== ESTADO GENERAL =====
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ===== CARGA DE DATOS =====
  Future<void> loadMoviesByGenre() async {
    _setLoading(true);
    try {
      _moviesByGenre = await ApiService.getMoviesByGenre();
    } catch (e) {
      _handleError('Error cargando películas por género', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRentedMovies(String userId) async {
    _setLoading(true);
    try {
      _rentedMovies = await ApiService.getRentedMovies(userId);
    } catch (e) {
      _handleError('Error cargando películas rentadas', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTop10Movies() async {
    _setLoading(true);
    try {
      _top10Movies = await ApiService.getTop10Movies();
    } catch (e) {
      _handleError('Error cargando Top 10', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadContinueWatching() async {
    try {
      _continueWatching = await ApiService.getContinueWatching();
      notifyListeners();
    } catch (e) {
      print('Error loading continue watching: $e');
    }
  }

  Future<void> loadWatchlist() async {
    try {
      _watchlist = await ApiService.getWatchlist();
      notifyListeners();
    } catch (e) {
      print('Error loading watchlist: $e');
    }
  }

  // ===== ACCIONES =====
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults = await ApiService.searchMovies(query);
    } catch (e) {
      _handleError('Error en la búsqueda', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLike(String movieId) async {
    try {
      final updatedMovie = await ApiService.toggleLike(movieId);

      _updateMovieInAllLists(updatedMovie);
      notifyListeners();
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> toggleWatchlist(String movieId) async {
    try {
      final updatedMovie = await ApiService.toggleWatchlist(movieId);

      _updateMovieInAllLists(updatedMovie);

      // Si ya estaba en la lista, la quitamos; si no, la agregamos
      final exists = _watchlist.any((m) => m.id == movieId);
      if (exists) {
        _watchlist.removeWhere((m) => m.id == movieId);
      } else {
        _watchlist.add(updatedMovie);
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling watchlist: $e');
    }
  }

  // ===== MÉTODOS INTERNOS =====
  void _updateMovieInAllLists(Movie updated) {
    for (var genre in _moviesByGenre) {
      for (int i = 0; i < genre.movies.length; i++) {
        if (genre.movies[i].id == updated.id) {
          genre.movies[i] = updated;
        }
      }
    }

    _updateInList(_rentedMovies, updated);
    _updateInList(_top10Movies, updated);
    _updateInList(_searchResults, updated);
    _updateInList(_continueWatching, updated);
    _updateInList(_watchlist, updated);
  }

  void _updateInList(List<Movie> list, Movie updated) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == updated.id) {
        list[i] = updated;
      }
    }
  }

  Movie? getMovieById(String id) {
    for (var genre in _moviesByGenre) {
      for (var movie in genre.movies) {
        if (movie.id == id) return movie;
      }
    }

    for (var list in [
      _rentedMovies,
      _top10Movies,
      _searchResults,
      _continueWatching,
      _watchlist
    ]) {
      for (var movie in list) {
        if (movie.id == id) return movie;
      }
    }

    return null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _handleError(String message, dynamic error) {
    _error = message;
    if (kDebugMode) {
      print('$message: $error');
    }
    notifyListeners();
  }
}
