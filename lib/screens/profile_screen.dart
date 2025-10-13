import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/movie_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  String? _email;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    // Llamar endpoint user-detail o profile v2
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _email = '---'; _name = 'Usuario';
    });
    // opcional: llamar GET /user-detail con ApiService si quieres información real
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.grey[800], child: const Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text(_name ?? '', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(_email ?? ''),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _logout, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)), child: const Text('Cerrar sesión', style: TextStyle(color: Colors.black))),
          ],
        ),
      ),
    );
  }
}
