import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/api';

  static Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username, // o 'username', ajusta según tu backend
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  static Future<List<MovieGenre>> getMoviesByGenre() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['genres'] != null) {
          return (data['genres'] as List)
              .map((genre) => MovieGenre.fromJson(genre))
              .toList();
        } else if (data['movies'] != null) {
          // Si tu API devuelve una lista plana bajo "movies"
          final movies = (data['movies'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();

          final Map<String, List<Movie>> grouped = {};
          for (var movie in movies) {
            grouped.putIfAbsent(movie.genre, () => []).add(movie);
          }

          return grouped.entries
              .map((e) => MovieGenre(name: e.key, movies: e.value))
              .toList();
        }
      }
      throw Exception('No se pudieron cargar las películas');
    } catch (e) {
      print('Error fetching movies: $e');
      rethrow;
    }
  }

  static Future<List<Movie>> getRentedMovies(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies/rented?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['movies'] != null) {
          return (data['movies'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      throw Exception('No se pudieron cargar las películas rentadas');
    } catch (e) {
      print('Error fetching rented movies: $e');
      rethrow;
    }
  }

  static Future<List<Movie>> getTop10Movies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies/top10'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['movies'] != null) {
          return (data['movies'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      throw Exception('No se pudo cargar el top 10');
    } catch (e) {
      print('Error fetching top 10 movies: $e');
      rethrow;
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies/search?q=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['movies'] != null) {
          return (data['movies'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching movies: $e');
      return [];
    }
  }
}
