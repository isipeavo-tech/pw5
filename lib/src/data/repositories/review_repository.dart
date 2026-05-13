import '../../domain/models/review.dart';
import '../database.dart';

class ReviewRepository {
  ReviewRepository(this._db);
  final AppDatabase _db;

  void insert(Review review) {
    _db.sqlite.execute(
      'INSERT OR REPLACE INTO reviews(id,userId,movieId,rating,comment) VALUES(?,?,?,?,?)',
      [
        review.id,
        review.userId,
        review.movieId,
        review.rating,
        review.comment,
      ],
    );
  }

  List<Review> getAll() {
    final rows = _db.sqlite.select(
      'SELECT id,userId,movieId,rating,comment FROM reviews',
    );
    return rows.map((row) => Review.fromMap(row)).toList();
  }

  Review? getById(String id) {
    final rows = _db.sqlite.select(
      'SELECT id,userId,movieId,rating,comment FROM reviews WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Review.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.sqlite.execute('DELETE FROM reviews WHERE id=?', [id]);
  }

  Map<String, List<Map<String, dynamic>>> dumpAllTables(AppDatabase db) {
    return {
      'users': db.sqlite.select('SELECT * FROM users').map((r) => r as Map<String, dynamic>).toList(),
      'movies': db.sqlite.select('SELECT * FROM movies').map((r) => r as Map<String, dynamic>).toList(),
      'subscriptions':
          db.sqlite.select('SELECT * FROM subscriptions').map((r) => r as Map<String, dynamic>).toList(),
      'view_history':
          db.sqlite.select('SELECT * FROM view_history').map((r) => r as Map<String, dynamic>).toList(),
      'reviews': db.sqlite.select('SELECT * FROM reviews').map((r) => r as Map<String, dynamic>).toList(),
    };
  }
}
