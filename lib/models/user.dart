class User {
  final String id;
  final String username;
  final String email;
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  // Constructor que mapea el JSON de Laravel
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      // Mapea 'full_name' (de Laravel) a 'username' (en Flutter)
      username: json['full_name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      // Mapea 'api_token' (de Laravel) a 'token' (en Flutter)
      token: json['api_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}
