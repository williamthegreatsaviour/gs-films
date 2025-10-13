class MovieModel {
  final int id;
  final String title;
  final String description;
  final String? poster;
  final List<dynamic>? files;
  final List<dynamic>? subtitles;
  final List<dynamic>? cast;
  final bool isFavorite;
  final bool inWatchlist;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    this.poster,
    this.files,
    this.subtitles,
    this.cast,
    this.isFavorite = false,
    this.inWatchlist = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    poster: json['poster'],
    files: json['files'] as List<dynamic>?,
    subtitles: json['subtitles'] as List<dynamic>?,
    cast: json['cast'] as List<dynamic>?,
    isFavorite: json['is_favorite'] == true || json['favorite'] == 1,
    inWatchlist: json['in_watchlist'] == true || json['watchlist'] == 1,
  );
}
