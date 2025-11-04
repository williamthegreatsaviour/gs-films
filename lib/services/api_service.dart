import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/user.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/services/storage_service.dart';

/// Excepción personalizada para manejar errores de API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {

  static const String baseUrl = 'https://gsfilms.com.mx/public/api';

  /// LOGIN
  static Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['user'] != null) {
          final user = User.fromJson(data['user']);
          await StorageService.saveUser(user);
          return user;
        } else {
          throw ApiException(data['message'] ?? 'Respuesta inválida del servidor.');
        }
      } else {
        final errorData = _tryDecode(response.body);
        throw ApiException(errorData['message'] ?? 'Error ${response.statusCode} en autenticación.');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor.');
    }
  }

  /// LOGOUT
  static Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final token = await StorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  /// Obtener lista de películas
  static Future<List<Movie>> getMovies() async {
    final url = Uri.parse('$baseUrl/movies');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Soporta respuestas con 'genres' o 'movies' directamente
      if (data['genres'] != null) {
        return (data['genres'] as List)
            .expand((genre) => genre['movies'])
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      } else if (data['movies'] != null) {
        return (data['movies'] as List)
            .map<Movie>((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw ApiException('Formato inesperado de respuesta en /movies.');
      }
    } else {
      throw ApiException('No se pudieron cargar las películas.');
    }
  }

  /// Obtener películas rentadas
  static Future<List<Movie>> getRentedMovies(String userId) async {
    final url = Uri.parse('$baseUrl/movies/rented?user_id=$userId');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['movies'] as List)
          .map<Movie>((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw ApiException('No se pudieron cargar las películas rentadas.');
    }
  }

  /// Buscar películas
  static Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/movies/search?q=$query');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['movies'] as List)
          .map<Movie>((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw ApiException('Error al realizar la búsqueda.');
    }
  }

  /// Obtener Top 10 de películas
  static Future<List<Movie>> getTopMovies() async {
    final url = Uri.parse('$baseUrl/top-movies');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = (data['data'] ?? data['movies'] ?? []) as List;
      return movies.map<Movie>((json) => Movie.fromJson(json)).toList();
    } else {
      throw ApiException('No se pudieron cargar las películas destacadas.');
    }
  }

  /// Like / Unlike de película
  static Future<Movie> toggleLike(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/like');
    final token = await StorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('No se pudo actualizar el "Like" de la película.');
    }
  }

  /// Agregar o quitar película de Mi Lista (watchlist)
  static Future<Movie> toggleWatchlist(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/watchlist');
    final token = await StorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('No se pudo actualizar "Mi Lista".');
    }
  }

  /// Obtener anuncio (Ad Tag URL)
  static Future<String?> getAdTagUrl(String movieId) async {
    final url = Uri.parse('$baseUrl/movies/$movieId/ad');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ad_tag_url'] as String?;
    } else {
      return null;
    }
  }

  /// Películas en progreso (Continue Watching)
  static Future<List<Movie>> getContinueWatching(String userId) async {
    final url = Uri.parse('$baseUrl/movies/continue-watching?user_id=$userId');
    final token = await StorageService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['movies'] as List)
          .map<Movie>((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw ApiException('No se pudo cargar Continue Watching.');
    }
  }

  /// Helper privado para intentar decodificar JSON con seguridad
  static Map<String, dynamic> _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }
}
