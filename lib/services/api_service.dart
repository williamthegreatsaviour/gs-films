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

  /// Obtener lista de películas
  static Future<List<Movie>> getMovies() async {
    final url = Uri.parse('$baseUrl/movies');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['movies'] as List).map((json) => Movie.fromJson(json)).toList();
    } else {
      throw ApiException('No se pudieron cargar las películas');
    }
  }

  /// Toggle Like de película
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

  /// Toggle Watchlist de película
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

  /// Obtener anuncio personalizado de la película (adTagUrl)
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

  /// Guardar progreso de reproducción
  static Future<void> saveProgress(String movieId, double seconds) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/progress');
    final token = await StorageService.getToken();

    await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'time': seconds}),
    );
  }

  /// Obtener progreso de reproducción
  static Future<double?> getProgress(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/progress');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['time'] as num?)?.toDouble();
    }
    return null;
  }
}
