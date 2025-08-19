class Movie {
  final String id;
  final String title;
  final String genre;
  final String duration;
  final String synopsis;
  final String posterUrl;
  final String videoUrl;
  final String? subtitleUrl;
  final List<String>? audioTracks;
  final bool isRented;
  final int views;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.synopsis,
    required this.posterUrl,
    required this.videoUrl,
    this.subtitleUrl,
    this.audioTracks,
    this.isRented = false,
    this.views = 0,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['titulo'] ?? json['title'] ?? '',
      genre: json['genero'] ?? json['genre'] ?? '',
      duration: json['duracion'] ?? json['duration'] ?? '',
      synopsis: json['sinopsis'] ?? json['synopsis'] ?? '',
      posterUrl: json['caratula'] ?? json['poster_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      subtitleUrl: json['subtitulo_url'],
      audioTracks: json['pistas_audio'] != null 
          ? List<String>.from(json['pistas_audio'])
          : null,
      isRented: json['rentada'] == 1 || json['is_rented'] == true,
      views: json['vistas'] ?? json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': title,
      'genero': genre,
      'duracion': duration,
      'sinopsis': synopsis,
      'caratula': posterUrl,
      'video_url': videoUrl,
      'subtitulo_url': subtitleUrl,
      'pistas_audio': audioTracks,
      'rentada': isRented ? 1 : 0,
      'vistas': views,
    };
  }
}

class MovieGenre {
  final String name;
  final List<Movie> movies;

  MovieGenre({
    required this.name,
    required this.movies,
  });

  factory MovieGenre.fromJson(Map<String, dynamic> json) {
    return MovieGenre(
      name: json['genero'] ?? json['genre'] ?? '',
      movies: (json['peliculas'] ?? json['movies'] ?? [])
          .map<Movie>((movie) => Movie.fromJson(movie))
          .toList(),
    );
  }
}