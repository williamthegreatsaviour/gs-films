import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://gsfilms.com.mx/gsfilms';
  
  static Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/endpoints/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true || data['status'] == 'success') {
          return User.fromJson(data['user'] ?? data);
        }
      }
      return null;
    } catch (e) {
      print('Login error: \$e');
      return null;
    }
  }

  static Future<List<MovieGenre>> getMoviesByGenre() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/endpoints/peliculas.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['genres'] != null) {
          return (data['genres'] as List)
              .map((genre) => MovieGenre.fromJson(genre))
              .toList();
        } else if (data['peliculas'] != null) {
          // Si las películas vienen en una lista plana, las agrupamos por género
          final movies = (data['peliculas'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
          
          final Map<String, List<Movie>> groupedMovies = {};
          for (var movie in movies) {
            if (!groupedMovies.containsKey(movie.genre)) {
              groupedMovies[movie.genre] = [];
            }
            groupedMovies[movie.genre]!.add(movie);
          }
          
          return groupedMovies.entries
              .map((entry) => MovieGenre(name: entry.key, movies: entry.value))
              .toList();
        }
      }
      return _getMockMoviesByGenre(); // Fallback to mock data
    } catch (e) {
      print('Error fetching movies: \$e');
      return _getMockMoviesByGenre(); // Fallback to mock data
    }
  }

  static Future<List<Movie>> getRentedMovies(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/endpoints/peliculasrentadas.php?user_id=\$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['peliculas'] != null) {
          return (data['peliculas'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      return _getMockRentedMovies(); // Fallback to mock data
    } catch (e) {
      print('Error fetching rented movies: \$e');
      return _getMockRentedMovies(); // Fallback to mock data
    }
  }

  static Future<List<Movie>> getTop10Movies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/endpoints/peliculas.php?top10=true'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['peliculas'] != null) {
          return (data['peliculas'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      return _getMockTop10Movies(); // Fallback to mock data
    } catch (e) {
      print('Error fetching top 10 movies: \$e');
      return _getMockTop10Movies(); // Fallback to mock data
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/endpoints/peliculas.php?search=\$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['peliculas'] != null) {
          return (data['peliculas'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching movies: \$e');
      return [];
    }
  }

  // datos de testeo
  static List<MovieGenre> _getMockMoviesByGenre() {
    return [
      MovieGenre(name: 'Acción', movies: [
        Movie(
          id: '1',
          title: 'Misión Imposible',
          genre: 'Acción',
          duration: '2h 28m',
          synopsis: 'Ethan Hunt y su equipo enfrentan su misión más peligrosa.',
          posterUrl: 'https://pixabay.com/get/g2cc66dda29170b61a85f75635bd2fb5310d5a0c61a2b574eef982379a9d88f1fecb04ca2b3136777f47d05f3735286feca1a4dbeffeb2eb933fd3f59000f78e0_1280.jpg',
          videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
          views: 15420,
        ),
        Movie(
          id: '2',
          title: 'Fast & Furious',
          genre: 'Acción',
          duration: '2h 17m',
          synopsis: 'La familia se reúne para la carrera más importante de sus vidas.',
          posterUrl: 'https://pixabay.com/get/ged4c179c81822dfb68b523e4937daa3fab785e26e9f28eb67470349be01d4f8284f5dd0b72796c77f041666e40ba1c38eee4ace94127eb2ab99122a80fd054e6_1280.jpg',
          videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
          views: 12350,
        ),
      ]),
      MovieGenre(name: 'Drama', movies: [
        Movie(
          id: '3',
          title: 'El Padrino',
          genre: 'Drama',
          duration: '2h 55m',
          synopsis: 'La historia de una familia de mafiosos italoamericanos.',
          posterUrl: 'https://pixabay.com/get/g121a7820b761b65c95bfd59d8c9cbae4e220e100ed7810b4cc1debaf1f126b29e09cee2bbd84d8f5c1e0a2b96ed74666f8edafc3c42984bb8ac9a3fcdfd2249b_1280.jpg',
          videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
          views: 25800,
        ),
      ]),
      MovieGenre(name: 'Terror', movies: [
        Movie(
          id: '4',
          title: 'El Conjuro',
          genre: 'Terror',
          duration: '1h 52m',
          synopsis: 'Investigadores paranormales ayudan a una familia aterrorizada.',
          posterUrl: 'https://pixabay.com/get/gb8f9ee3b8d2588446c049afc128b54a5a78e180b475e34fded6e4a1da0db5e78276a1c2fa6a36be4ea4d66e74c484cd9d78b4a8f94668cac8ceb25f432811ef7_1280.jpg',
          videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
          views: 8950,
        ),
      ]),
      MovieGenre(name: 'Sci-Fi', movies: [
        Movie(
          id: '5',
          title: 'Blade Runner 2049',
          genre: 'Sci-Fi',
          duration: '2h 44m',
          synopsis: 'Un blade runner descubre un secreto que lo lleva a Rick Deckard.',
          posterUrl: 'https://pixabay.com/get/g95e8f543849c7b1a9d84ced696e371875d92892b254d41e7f633e653f5e3ae49783b28ed57f149e89fe1b03d3807eddd7eaf013aae15176651b88043dcb8a097_1280.jpg',
          videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
          views: 11200,
        ),
      ]),
    ];
  }

  static List<Movie> _getMockRentedMovies() {
    return [
      Movie(
        id: '1',
        title: 'Misión Imposible',
        genre: 'Acción',
        duration: '2h 28m',
        synopsis: 'Ethan Hunt y su equipo enfrentan su misión más peligrosa.',
        posterUrl: 'https://pixabay.com/get/g2cc66dda29170b61a85f75635bd2fb5310d5a0c61a2b574eef982379a9d88f1fecb04ca2b3136777f47d05f3735286feca1a4dbeffeb2eb933fd3f59000f78e0_1280.jpg',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        isRented: true,
        views: 15420,
      ),
      Movie(
        id: '3',
        title: 'El Padrino',
        genre: 'Drama',
        duration: '2h 55m',
        synopsis: 'La historia de una familia de mafiosos italoamericanos.',
        posterUrl: 'https://pixabay.com/get/g121a7820b761b65c95bfd59d8c9cbae4e220e100ed7810b4cc1debaf1f126b29e09cee2bbd84d8f5c1e0a2b96ed74666f8edafc3c42984bb8ac9a3fcdfd2249b_1280.jpg',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
        isRented: true,
        views: 25800,
      ),
    ];
  }

  static List<Movie> _getMockTop10Movies() {
    return [
      Movie(
        id: '3',
        title: 'El Padrino',
        genre: 'Drama',
        duration: '2h 55m',
        synopsis: 'La historia de una familia de mafiosos italoamericanos.',
        posterUrl: 'https://pixabay.com/get/g121a7820b761b65c95bfd59d8c9cbae4e220e100ed7810b4cc1debaf1f126b29e09cee2bbd84d8f5c1e0a2b96ed74666f8edafc3c42984bb8ac9a3fcdfd2249b_1280.jpg',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
        views: 25800,
      ),
      Movie(
        id: '1',
        title: 'Misión Imposible',
        genre: 'Acción',
        duration: '2h 28m',
        synopsis: 'Ethan Hunt y su equipo enfrentan su misión más peligrosa.',
        posterUrl: 'https://pixabay.com/get/g2cc66dda29170b61a85f75635bd2fb5310d5a0c61a2b574eef982379a9d88f1fecb04ca2b3136777f47d05f3735286feca1a4dbeffeb2eb933fd3f59000f78e0_1280.jpg',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        views: 15420,
      ),
      Movie(
        id: '2',
        title: 'Fast & Furious',
        genre: 'Acción',
        duration: '2h 17m',
        synopsis: 'La familia se reúne para la carrera más importante de sus vidas.',
        posterUrl: 'https://pixabay.com/get/ged4c179c81822dfb68b523e4937daa3fab785e26e9f28eb67470349be01d4f8284f5dd0b72796c77f041666e40ba1c38eee4ace94127eb2ab99122a80fd054e6_1280.jpg',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        views: 12350,
      ),
    ];
  }
}
