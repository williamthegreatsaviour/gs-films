import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/gsfilms/api';

  // ===== LOGIN =====
  static Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Error de login');
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // ===== MOVIES BY GENRE =====
  static Future<List<MovieGenre>> getMoviesByGenre() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/genres'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => MovieGenre.fromJson(json)).toList();
      } else {
        throw Exception('Error cargando películas por género');
      }
    } catch (e) {
      print('getMoviesByGenre error: $e');
      return [];
    }
  }

  // ===== TOP 10 MOVIES =====
  static Future<List<Movie>> getTop10Movies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/top10'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error cargando Top 10');
      }
    } catch (e) {
      print('getTop10Movies error: $e');
      return [];
    }
  }

  // ===== RENTED MOVIES =====
  static Future<List<Movie>> getRentedMovies(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/movies/rented?user_id=$userId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error cargando películas rentadas');
      }
    } catch (e) {
      print('getRentedMovies error: $e');
      return [];
    }
  }

  // ===== SEARCH MOVIES =====
  static Future<List<Movie>> searchMovies(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/movies/search?query=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error en la búsqueda');
      }
    } catch (e) {
      print('searchMovies error: $e');
      return [];
    }
  }

  // ===== CONTINUE WATCHING =====
  static Future<List<Movie>> getContinueWatching() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/continue-watching'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error cargando Continue Watching');
      }
    } catch (e) {
      print('getContinueWatching error: $e');
      return [];
    }
  }

  // ===== WATCHLIST =====
  static Future<List<Movie>> getWatchlist() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/watchlist'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error cargando Watchlist');
      }
    } catch (e) {
      print('getWatchlist error: $e');
      return [];
    }
  }

  // ===== TOGGLE LIKE =====
  static Future<Movie> toggleLike(String movieId) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/movies/$movieId/toggle-like'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Error al dar like');
      }
    } catch (e) {
      print('toggleLike error: $e');
      throw e;
    }
  }

  // ===== TOGGLE WATCHLIST =====
  static Future<Movie> toggleWatchlist(String movieId) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/movies/$movieId/toggle-watchlist'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Error al actualizar Watchlist');
      }
    } catch (e) {
      print('toggleWatchlist error: $e');
      throw e;
    }
  }
}
