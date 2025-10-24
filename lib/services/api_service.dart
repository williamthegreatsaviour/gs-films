import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/api';

  // ================== LOGIN ==================
  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ================== REGISTER ==================
  static Future<User?> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: userData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ================== WATCHLIST ==================
  // Obtener watchlist
  static Future<List<dynamic>> getWatchlist(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/watchlist/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Agregar a watchlist
  static Future<bool> addToWatchlist({
    required int userId,
    required int entertainmentId,
    String? type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/watchlist/add'),
        body: {
          'user_id': userId.toString(),
          'entertainment_id': entertainmentId.toString(),
          'type': type ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Eliminar de watchlist
  static Future<bool> removeFromWatchlist({
    required int userId,
    required int entertainmentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/watchlist/remove'),
        body: {
          'user_id': userId.toString(),
          'entertainment_id': entertainmentId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ================== LIKES ==================
  // Alternar like
  static Future<bool> toggleLike({
    required int userId,
    required int movieId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/like/toggle'),
        body: {
          'user_id': userId.toString(),
          'movie_id': movieId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Obtener likes del usuario
  static Future<List<int>> getUserLikes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/likes/user/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<int> likes = List<int>.from(data['data']);
        return likes;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Contar likes de una película
  static Future<int> getMovieLikes(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/likes/movie/$movieId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['likes'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
