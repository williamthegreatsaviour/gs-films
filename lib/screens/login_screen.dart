import 'package:cinepulso/providers/auth_provider.dart';
import 'package:cinepulso/screens/home_screen.dart';
import 'package:cinepulso/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GSFilmsColors.neonGold,
                      GSFilmsColors.darkGold,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.movie,
                  size: 60,
                  color: GSFilmsColors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'GSFilms',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: GSFilmsColors.neonGold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 50),
              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        labelStyle:
                            const TextStyle(color: GSFilmsColors.lightGray),
                        prefixIcon: const Icon(Icons.person,
                            color: GSFilmsColors.neonGold),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.mediumGray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.neonGold),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.error),
                        ),
                        filled: true,
                        fillColor: GSFilmsColors.charcoal,
                      ),
                      style: const TextStyle(color: GSFilmsColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu usuario';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle:
                            const TextStyle(color: GSFilmsColors.lightGray),
                        prefixIcon: const Icon(Icons.lock,
                            color: GSFilmsColors.neonGold),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: GSFilmsColors.lightGray,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.mediumGray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.neonGold),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: GSFilmsColors.error),
                        ),
                        filled: true,
                        fillColor: GSFilmsColors.charcoal,
                      ),
                      style: const TextStyle(color: GSFilmsColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.error != null) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: GSFilmsColors.error
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: GSFilmsColors.error),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error,
                                        color: GSFilmsColors.error),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.error!,
                                        style: const TextStyle(
                                            color: GSFilmsColors.error),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GSFilmsColors.neonGold,
                              foregroundColor: GSFilmsColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        GSFilmsColors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Iniciar Sesión',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: GSFilmsColors.black,
                                        ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
