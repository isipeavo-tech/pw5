import 'identity.dart';

class Review implements Identity {
  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.comment,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      userId: map['userId'] as String,
      movieId: map['movieId'] as String,
      rating: _asInt(map['rating']),
      comment: map['comment'] as String,
    );
  }

  @override
  final String id;
  final String userId;
  final String movieId;
  final int rating;
  final String comment;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'movieId': movieId,
        'rating': rating,
        'comment': comment,
      };

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Expected an integer', value);
  }

  @override
  String toString() => 'user=$userId movie=$movieId rating=$rating "$comment"';
}
