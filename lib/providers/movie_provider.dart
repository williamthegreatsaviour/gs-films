import 'package:flutter/foundation.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/api_service.dart';

class MovieProvider with ChangeNotifier {
  // === Películas generales (catálogo) ===
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  // === Películas rentadas (para MyMoviesScreen) ===
  List<Movie> _rentedMovies = [];

  // Getters públicos
  List<Movie> get movies => _movies;
  List<Movie> get rentedMovies => _rentedMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // === Cargar catálogo principal ===
  Future<void> fetchMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movies = await ApiService.getMovies();

      // Obtener adTagUrl personalizado para cada película
      for (int i = 0; i < _movies.length; i++) {
        final adUrl = await ApiService.getAdTagUrl(_movies[i].id);
        _movies[i] = Movie(
          id: _movies[i].id,
          title: _movies[i].title,
          genre: _movies[i].genre,
          duration: _movies[i].duration,
          synopsis: _movies[i].synopsis,
          posterUrl: _movies[i].posterUrl,
          videoUrl: _movies[i].videoUrl,
          subtitleUrl: _movies[i].subtitleUrl,
          audioTracks: _movies[i].audioTracks,
          isRented: _movies[i].isRented,
          views: _movies[i].views,
          adTagUrl: adUrl ?? _movies[i].adTagUrl,
        );
      }
    } catch (e) {
      _error = 'No se pudieron cargar las películas. Verifica tu conexión.';
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // === Cargar películas rentadas ===
  Future<void> loadRentedMovies(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rentedMovies = await ApiService.getRentedMovies(userId);
    } catch (e) {
      _error = 'No se pudieron cargar tus películas rentadas.';
      _rentedMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // === Reintentar la última operación (solo para catálogo principal) ===
  Future<void> retry() async {
    await fetchMovies();
  }

  // === Toggle Like ===
  Future<Movie> toggleLike(String movieId) async {
    try {
      final updatedMovie = await ApiService.toggleLike(movieId);
      _movies = _movies.map((m) => m.id == movieId ? updatedMovie : m).toList();
      notifyListeners();
      return updatedMovie;
    } catch (e) {
      rethrow;
    }
  }

  // === Toggle Watchlist ===
  Future<Movie> toggleWatchlist(String movieId) async {
    try {
      final updatedMovie = await ApiService.toggleWatchlist(movieId);
      _movies = _movies.map((m) => m.id == movieId ? updatedMovie : m).toList();
      notifyListeners();
      return updatedMovie;
    } catch (e) {
      rethrow;
    }
  }
}
