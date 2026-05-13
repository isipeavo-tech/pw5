import '../../domain/models/cinema_user.dart';
import '../database.dart';

class UserRepository {
  UserRepository(this._db);
  final AppDatabase _db;

  void insert(CinemaUser user) {
    _db.sqlite.execute(
      'INSERT OR REPLACE INTO users(id,name,email) VALUES(?,?,?)',
      [user.id, user.name, user.email],
    );
  }

  List<CinemaUser> getAll() {
    final rows = _db.sqlite.select('SELECT id,name,email FROM users');
    return rows.map((row) => CinemaUser.fromMap(row)).toList();
  }

  CinemaUser? getById(String id) {
    final rows = _db.sqlite.select(
      'SELECT id,name,email FROM users WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? CinemaUser.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.sqlite.execute('DELETE FROM users WHERE id=?', [id]);
  }
}
