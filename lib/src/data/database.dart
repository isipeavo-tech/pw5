import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sql;

class AppDatabase {
  AppDatabase(String filePath) : _sqlite = sql.sqlite3.open(filePath) {
    _createTables();
  }

  factory AppDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'cinema.db');
    return AppDatabase(filePath);
  }

  final sql.Database _sqlite;
  sql.Database get sqlite => _sqlite;

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS movies (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        durationMinutes INTEGER NOT NULL,
        releaseYear INTEGER NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS subscriptions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        price REAL NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS view_history (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        movieId TEXT NOT NULL,
        watchDate TEXT NOT NULL,
        progressMinutes INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (movieId) REFERENCES movies(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        movieId TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (movieId) REFERENCES movies(id) ON DELETE CASCADE
      );
    ''');
  }

  void close() {
    _sqlite.dispose();
  }
}
