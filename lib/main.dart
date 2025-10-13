import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const GSFilmsApp());
}

class GSFilmsApp extends StatelessWidget {
  const GSFilmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GSFilms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/splash',
      routes: appRoutes,
    );
  }
}

