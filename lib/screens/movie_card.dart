import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/movie-detail', arguments: movie['id']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          movie['poster'] ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}
