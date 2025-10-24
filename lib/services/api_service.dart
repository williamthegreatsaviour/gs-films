import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/user.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/storage_service.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/api';

  /// LOGIN
  static Future<User?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['user'] != null) {
          final user = User.fromJson(data['user']);
          await StorageService.saveUser(user);
          return user;
        } else {
          throw ApiException(data['message'] ?? 'Usuario o contraseña incorrectos');
        }
      } else {
        throw ApiException('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión. Intenta nuevamente.');
    }
  }

  /// LISTADO DE PELÍCULAS
  static Future<List<Movie>> getMovies() async {
    final url = Uri.parse('$baseUrl/movies');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = (data['movies'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw ApiException('No se pudieron cargar las películas');
    }
  }

  /// TOP 10 PELÍCULAS (más vistas o likes)
  static Future<List<Movie>> getTopMovies() async {
    final url = Uri.parse('$baseUrl/movies/top10');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = (data['movies'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw ApiException('No se pudieron cargar las películas top 10');
    }
  }

  /// PELÍCULAS POR GÉNERO
  static Future<List<Movie>> getMoviesByGenre(String genreId) async {
    final url = Uri.parse('$baseUrl/genres/$genreId/movies');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = (data['movies'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw ApiException('No se pudieron cargar las películas por género');
    }
  }

  /// DETALLE DE PELÍCULA
  static Future<Movie> getMovieDetail(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data['movie']);
    } else {
      throw ApiException('No se pudo cargar el detalle de la película');
    }
  }

  /// TOGGLE LIKE
  static Future<Movie> toggleLike(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/like');
    final token = await StorageService.getToken();

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('No se pudo actualizar el like');
    }
  }

  /// TOGGLE WATCHLIST
  static Future<Movie> toggleWatchlist(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/watchlist');
    final token = await StorageService.getToken();

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('No se pudo actualizar Mi Lista');
    }
  }

  /// GET ADS PERSONALIZADOS
  static Future<String?> getAdTagUrl(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/ad');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ad_tag_url'] as String?;
    } else {
      return null;
    }
  }

  /// CONTINUE WATCHING
  static Future<List<Movie>> getContinueWatching() async {
    final url = Uri.parse('$baseUrl/continue-watching');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = (data['movies'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw ApiException('No se pudo cargar la lista de Continue Watching');
    }
  }
}
