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

  /// Inicializa la sesión si hay un usuario guardado
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final hasSession = await StorageService.hasSession();
      if (hasSession) {
        _user = await StorageService.getUser();
        _isLoggedIn = _user != null;
      }
    } catch (e, st) {
      log('Error initializing auth: $e', stackTrace: st);
    } finally {
      _setLoading(false);
    }
  }

  /// Login con backend
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await ApiService.login(username, password);

      if (user != null) {
        // Login exitoso
        _user = user;
        _isLoggedIn = true;
        await StorageService.saveUser(user); // persistencia segura
        _setLoading(false);
        return true;
      } else {
        // Login fallido (credenciales incorrectas)
        _setError('Usuario o contraseña incorrectos');
      }
    } on ApiException catch (e) {
      // Error específico del backend
      _setError(e.message);
      log('ApiException login: ${e.message}');
    } catch (e, st) {
      // Error de conexión u otros errores
      _setError('Error de conexión. Intenta nuevamente.');
      log('Login error: $e', stackTrace: st);
    }

    _setLoading(false);
    return false;
  }

  /// Logout y limpieza de sesión
  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    await StorageService.clearSession();
    notifyListeners();
  }

  /// Limpia errores visibles en UI
  void clearError() => _setError(null);

  /// -----------------------
  /// Métodos internos
  /// -----------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }
}
