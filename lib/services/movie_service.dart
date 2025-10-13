import 'package:dio/dio.dart';
import 'api_service.dart';

class MovieService {
  final Dio _dio = ApiService().dio;

  Future<Map<String, dynamic>> getDashboard() async {
    final resp = await _dio.get('/v2/dashboard-detail-data');
    return Map<String, dynamic>.from(resp.data ?? {});
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final resp = await _dio.get('/v2/movie-details', queryParameters: {'movie_id': movieId});
    return Map<String, dynamic>.from(resp.data ?? {});
  }

  Future<bool> toggleFavorite(int movieId) async {
    try {
      final resp = await _dio.post('/favorite/toggle', data: {'movie_id': movieId});
      return resp.data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleWatchlist(int movieId) async {
    try {
      final resp = await _dio.post('/watchlist/toggle', data: {'movie_id': movieId});
      return resp.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
