import '../../domain/models/view_history.dart';
import '../database.dart';

class ViewHistoryRepository {
  ViewHistoryRepository(this._db);
  final AppDatabase _db;

  void insert(ViewHistory history) {
    _db.sqlite.execute(
      'INSERT OR REPLACE INTO view_history(id,userId,movieId,watchDate,progressMinutes) VALUES(?,?,?,?,?)',
      [
        history.id,
        history.userId,
        history.movieId,
        history.watchDate.toIso8601String(),
        history.progressMinutes,
      ],
    );
  }

  List<ViewHistory> getAll() {
    final rows = _db.sqlite.select(
      'SELECT id,userId,movieId,watchDate,progressMinutes FROM view_history',
    );
    return rows.map((row) => ViewHistory.fromMap(row)).toList();
  }

  ViewHistory? getById(String id) {
    final rows = _db.sqlite.select(
      'SELECT id,userId,movieId,watchDate,progressMinutes FROM view_history WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? ViewHistory.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.sqlite.execute('DELETE FROM view_history WHERE id=?', [id]);
  }
}
