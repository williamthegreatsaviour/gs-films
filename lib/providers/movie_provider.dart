import 'package:flutter/foundation.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/api_service.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  Future<void> retry() async {
    await fetchMovies();
  }

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
