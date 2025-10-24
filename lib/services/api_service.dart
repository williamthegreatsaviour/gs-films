import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/gsfilms/api';

  // LOGIN
  static Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'email': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body)['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // GET MOVIES
  static Future<List<Movie>> getMovies({String? genreId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies${genreId != null ? '?genre_id=$genreId' : ''}'),
      );

      if (response.statusCode == 200) {
        final List moviesJson = json.decode(response.body)['data'] ?? [];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // LIKE A MOVIE
  static Future<bool> likeMovie(String movieId, String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likes'),
        headers: {'Authorization': 'Bearer $userToken'},
        body: {'movie_id': movieId},
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // WATCHLIST
  static Future<bool> addToWatchlist(String movieId, String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/watchlist'),
        headers: {'Authorization': 'Bearer $userToken'},
        body: {'movie_id': movieId},
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> removeFromWatchlist(String movieId, String userToken) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/watchlist/$movieId'),
        headers: {'Authorization': 'Bearer $userToken'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Movie>> getWatchlist(String userToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/watchlist'),
        headers: {'Authorization': 'Bearer $userToken'},
      );

      if (response.statusCode == 200) {
        final List moviesJson = json.decode(response.body)['data'] ?? [];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // CONTINUE WATCHING
  static Future<List<Movie>> getContinueWatching(String userToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/continue-watching'),
        headers: {'Authorization': 'Bearer $userToken'},
      );

      if (response.statusCode == 200) {
        final List moviesJson = json.decode(response.body)['data'] ?? [];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
