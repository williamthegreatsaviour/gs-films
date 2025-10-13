import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final Dio _dio = ApiService().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final resp = await _dio.post('/login', data: {'email': email, 'password': password});
      final data = resp.data ?? {};
      String? token;
      if (data['token'] != null) token = data['token'];
      else if (data['data'] != null && data['data']['token'] != null) token = data['data']['token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
      return Map<String, dynamic>.from(data);
    } on DioError catch (e) {
      return {'error': e.response?.data ?? e.message};
    }
  }

  Future<void> logout() async {
    try {
      await _dio.get('/logout');
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
