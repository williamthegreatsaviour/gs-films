import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cinepulso/theme.dart';
import 'package:cinepulso/providers/auth_provider.dart';
import 'package:cinepulso/providers/movie_provider.dart';
import 'package:cinepulso/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: GSFilmsColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const GSFilmsApp());
}

class GSFilmsApp extends StatelessWidget {
  const GSFilmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'GSFilms - Tu portal al cine',
        debugShowCheckedModeBanner: false,
        theme: darkTheme, // Always use dark theme as per design requirements
        home: const SplashScreen(),
      ),
    );
  }
}
