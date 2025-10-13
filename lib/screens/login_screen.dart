import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  Future<void> _onLogin() async {
    setState(() => _loading = true);
    final resp = await _auth.login(_email.text.trim(), _pass.text);
    setState(() => _loading = false);
    if (resp.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['error'].toString())));
      return;
    }
    // asumo success
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/splash.png', width: 150),
                const SizedBox(height: 20),
                const Text('Inicia sesión', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.email), labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), labelText: 'Contraseña'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
                    onPressed: _loading ? null : _onLogin,
                    child: _loading ? const CircularProgressIndicator(color: Colors.black) : const Text('Entrar', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
