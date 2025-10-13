import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class MovieService {
  Future<Map<String, dynamic>> getDashboardData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v2/dashboard-detail-data'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos del dashboard');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(String token, int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v2/movie-details?movie_id=$movieId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener detalles de la película');
    }
  }
}
