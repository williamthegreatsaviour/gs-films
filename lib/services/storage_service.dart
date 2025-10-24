import 'dart:convert';
import 'package:cinepulso/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class StorageService {
  static final _secureStorage = const FlutterSecureStorage();

  static const _keyUser = 'user_data';
  static const _keyToken = 'user_token';

  /// Guarda el usuario y token de sesión de forma segura
  static Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.write(key: _keyUser, value: userJson);

    // Crea un token seguro a partir del username y timestamp
    final token = base64Url.encode(sha256.convert(utf8.encode('${user.username}_${DateTime.now().millisecondsSinceEpoch}')).bytes);
    await _secureStorage.write(key: _keyToken, value: token);
  }

  /// Obtiene usuario guardado
  static Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: _keyUser);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Obtiene token seguro
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  /// Verifica si hay sesión activa
  static Future<bool> hasSession() async {
    final user = await _secureStorage.read(key: _keyUser);
    final token = await _secureStorage.read(key: _keyToken);
    return user != null && token != null;
  }

  /// Limpia sesión
  static Future<void> clearSession() async {
    await _secureStorage.delete(key: _keyUser);
    await _secureStorage.delete(key: _keyToken);
  }
}
