import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinepulso/models/user.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _userKey = 'gsfilms_user';
  static const String _tokenKey = 'gsfilms_token';
  static const String _sessionKey = 'gsfilms_session';

  static Future<void> saveUser(User user) async {
    try {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
      if (user.token != null) {
        await _secureStorage.write(key: _tokenKey, value: user.token!);
      }
      await saveSession(true);
    } catch (e) {
      print('Error saving user: \$e');
    }
  }

  static Future<User?> getUser() async {
    try {
      final userString = await _secureStorage.read(key: _userKey);
      if (userString != null) {
        final userData = jsonDecode(userString);
        return User.fromJson(userData);
      }
    } catch (e) {
      print('Error getting user: \$e');
    }
    return null;
  }

  static Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      print('Error getting token: \$e');
      return null;
    }
  }

  static Future<void> saveSession(bool hasSession) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_sessionKey, hasSession);
    } catch (e) {
      print('Error saving session: \$e');
    }
  }

  static Future<bool> hasSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_sessionKey) ?? false;
    } catch (e) {
      print('Error checking session: \$e');
      return false;
    }
  }

  static Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: _userKey);
      await _secureStorage.delete(key: _tokenKey);
      await saveSession(false);
    } catch (e) {
      print('Error clearing session: \$e');
    }
  }

  static Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing all data: \$e');
    }
  }
}