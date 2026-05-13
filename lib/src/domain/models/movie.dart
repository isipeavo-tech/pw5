import 'identity.dart';

class Movie implements Identity {
  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.durationMinutes,
    required this.releaseYear,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as String,
      title: map['title'] as String,
      genre: map['genre'] as String,
      durationMinutes: _asInt(map['durationMinutes']),
      releaseYear: _asInt(map['releaseYear']),
    );
  }

  @override
  final String id;
  final String title;
  final String genre;
  final int durationMinutes;
  final int releaseYear;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'genre': genre,
        'durationMinutes': durationMinutes,
        'releaseYear': releaseYear,
      };

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Expected an integer', value);
  }

  @override
  String toString() => '$title ($releaseYear, $durationMinutes min, $genre)';
}
