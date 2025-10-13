import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final poster = movie['poster'] ?? movie['thumbnail'] ?? '';
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/movie-detail', arguments: movie['id']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: poster, fit: BoxFit.cover, placeholder: (_,__)=>Container(color: Colors.grey[800])),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(color: Colors.black54, padding: const EdgeInsets.all(6),
                child: Text(movie['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }
}
