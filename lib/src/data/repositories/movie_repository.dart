import '../../domain/models/movie.dart';
import '../database.dart';

class MovieRepository {
  MovieRepository(this._db);
  final AppDatabase _db;

  void insert(Movie movie) {
    _db.sqlite.execute(
      'INSERT OR REPLACE INTO movies(id,title,genre,durationMinutes,releaseYear) VALUES(?,?,?,?,?)',
      [movie.id, movie.title, movie.genre, movie.durationMinutes, movie.releaseYear],
    );
  }

  List<Movie> getAll() {
    final rows = _db.sqlite.select(
      'SELECT id,title,genre,durationMinutes,releaseYear FROM movies',
    );
    return rows.map((row) => Movie.fromMap(row)).toList();
  }

  Movie? getById(String id) {
    final rows = _db.sqlite.select(
      'SELECT id,title,genre,durationMinutes,releaseYear FROM movies WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Movie.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.sqlite.execute('DELETE FROM movies WHERE id=?', [id]);
  }
}
