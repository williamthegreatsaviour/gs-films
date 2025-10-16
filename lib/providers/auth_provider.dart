import 'dart:developer';

import 'package:cinepulso/models/user.dart';
import 'package:cinepulso/services/api_service.dart';
import 'package:cinepulso/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hasSession = await StorageService.hasSession();
      if (hasSession) {
        _user = await StorageService.getUser();
        _isLoggedIn = _user != null;
      }
    } catch (e) {
      print('Error initializing auth: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await ApiService.login(username, password);
      if (user != null) {
        _user = user;
        _isLoggedIn = true;
        await StorageService.saveUser(user);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        log(
          'Login fallido: credenciales incorrectas para usuario "$username"',
          name: 'AuthProvider',
          level: 900, // Level.WARNING
        );
      }
    } catch (e) {
      _error = 'Error de conexión';
      print('Login error: \$e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    await StorageService.clearSession();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
