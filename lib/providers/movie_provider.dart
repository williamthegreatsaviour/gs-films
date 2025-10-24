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
      final fetchedMovies = await ApiService.getMovies(); // Asegúrate de que tu ApiService tenga getMovies()
      _movies = fetchedMovies;
    } catch (e) {
      _error = 'Error cargando películas';
      if (kDebugMode) print('MovieProvider fetchMovies error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Movie> toggleLike(String movieId) async {
    final index = _movies.indexWhere((m) => m.id == movieId);
    if (index != -1) {
      final movie = _movies[index];
      _movies[index] = Movie(
        id: movie.id,
        title: movie.title,
        genre: movie.genre,
        duration: movie.duration,
        synopsis: movie.synopsis,
        posterUrl: movie.posterUrl,
        videoUrl: movie.videoUrl,
        subtitleUrl: movie.subtitleUrl,
        audioTracks: movie.audioTracks,
        isRented: movie.isRented,
        views: movie.views,
        adTagUrl: movie.adTagUrl,
        // Cambio solo isLiked
        isLiked: !movie.isLiked,
        inWatchlist: movie.inWatchlist,
      );
      notifyListeners();
      return _movies[index];
    }
    throw Exception('Película no encontrada');
  }

  Future<Movie> toggleWatchlist(String movieId) async {
    final index = _movies.indexWhere((m) => m.id == movieId);
    if (index != -1) {
      final movie = _movies[index];
      _movies[index] = Movie(
        id: movie.id,
        title: movie.title,
        genre: movie.genre,
        duration: movie.duration,
        synopsis: movie.synopsis,
        posterUrl: movie.posterUrl,
        videoUrl: movie.videoUrl,
        subtitleUrl: movie.subtitleUrl,
        audioTracks: movie.audioTracks,
        isRented: movie.isRented,
        views: movie.views,
        adTagUrl: movie.adTagUrl,
        isLiked: movie.isLiked,
        // Cambio solo inWatchlist
        inWatchlist: !movie.inWatchlist,
      );
      notifyListeners();
      return _movies[index];
    }
    throw Exception('Película no encontrada');
  }
}
