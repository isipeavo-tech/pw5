import 'identity.dart';

class ViewHistory implements Identity {
  ViewHistory({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.watchDate,
    required this.progressMinutes,
  });

  factory ViewHistory.fromMap(Map<String, dynamic> map) {
    return ViewHistory(
      id: map['id'] as String,
      userId: map['userId'] as String,
      movieId: map['movieId'] as String,
      watchDate: DateTime.parse(map['watchDate'] as String),
      progressMinutes: _asInt(map['progressMinutes']),
    );
  }

  @override
  final String id;
  final String userId;
  final String movieId;
  final DateTime watchDate;
  final int progressMinutes;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'movieId': movieId,
        'watchDate': watchDate.toIso8601String(),
        'progressMinutes': progressMinutes,
      };

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Expected an integer', value);
  }

  @override
  String toString() =>
      'user=$userId movie=$movieId ${watchDate.toLocal().toIso8601String().substring(0, 10)} $progressMinutes min';
}
