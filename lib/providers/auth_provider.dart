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

  // Inicializar sesión segura
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
      log('Error initializing auth: $e', level: 900);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login seguro
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await ApiService.login(username, password);
      if (user != null) {
        _user = user;
        _isLoggedIn = true;
        await StorageService.saveUser(user); // Guardado seguro
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        log('Login fallido para usuario "$username"', level: 900);
      }
    } catch (e) {
      _error = 'Error de conexión';
      log('Login error: $e', level: 1000);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
