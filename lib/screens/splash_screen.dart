import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/providers/auth_provider.dart';
import 'package:cinepulso/screens/login_screen.dart';
import 'package:cinepulso/screens/home_screen.dart';
import 'package:cinepulso/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // NOTA: Reemplaza AuthProvider por el provider real si tiene un nombre diferente
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();
    
    if (!mounted) return;
    
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo GSFilms
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: GSFilmsColors.neonGold.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://pixabay.com/get/gf8b2eac757136f378deb54ab8d62cdc3affecac337eb9f9cf5caf0793a061990b01f792f128d4a5f06d0930f2ba863e874f15e275524632a6da9bc1e263f6d85_1280.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                             // Esto ayuda a manejar errores en la consola si la imagen falla
                             return Container(); 
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // **LÓGICA DE RESERVA MODIFICADA**
                            // Muestra la imagen adjunta 'splash.png' usando Image.asset
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                // **Ruta Asumida:** Debes asegurarte de que 'splash.png' está en esta ruta.
                                'assets/images/splash.png', 
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Si la imagen de asset falla, muestra un fallback simple.
                                  return Container(
                                    color: GSFilmsColors.darkGold,
                                    child: const Center(
                                      child: Text(
                                        'GS', 
                                        style: TextStyle(color: GSFilmsColors.black, fontSize: 60)
                                      ),
                                    ),
                                  );
                                }
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // GSFilms Text
                    Text(
                      'GSFilms',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: GSFilmsColors.neonGold,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tu portal al cine',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: GSFilmsColors.lightGray,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 50),
                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GSFilmsColors.neonGold,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
