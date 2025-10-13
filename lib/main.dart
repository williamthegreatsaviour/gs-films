import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
      ),
      initialRoute: '/splash',
      routes: appRoutes,
    );
  }
}
