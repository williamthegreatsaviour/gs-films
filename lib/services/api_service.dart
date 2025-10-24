import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/user.dart';
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
          // Guardar token seguro
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

  /// Otras funciones de la API pueden usar StorageService.getToken() para autenticación
}
