import 'dart:io';

import 'package:online_cinema/online_cinema.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('toMap/fromMap', () {
    test('Movie toMap and fromMap produce the same object', () {
      final original = Movie(
        id: '1',
        title: 'Inception',
        genre: 'Sci-Fi',
        durationMinutes: 148,
        releaseYear: 2010,
      );
      final map = original.toMap();
      final restored = Movie.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.genre, original.genre);
      expect(restored.durationMinutes, original.durationMinutes);
      expect(restored.releaseYear, original.releaseYear);
    });

    test('CinemaUser toMap and fromMap produce the same object', () {
      final original = CinemaUser(id: '1', name: 'Alice', email: 'alice@test.com');
      final map = original.toMap();
      final restored = CinemaUser.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.email, original.email);
    });

    test('Subscription toMap and fromMap produce the same object', () {
      final original = Subscription(
        id: '1',
        userId: '1',
        type: 'monthly',
        price: 499.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 2, 1),
      );
      final map = original.toMap();
      final restored = Subscription.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.type, original.type);
      expect(restored.price, original.price);
    });

    test('ViewHistory toMap and fromMap produce the same object', () {
      final original = ViewHistory(
        id: '1',
        userId: '1',
        movieId: '1',
        watchDate: DateTime(2026, 5, 1, 14, 30),
        progressMinutes: 60,
      );
      final map = original.toMap();
      final restored = ViewHistory.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.progressMinutes, original.progressMinutes);
    });

    test('Review toMap and fromMap produce the same object', () {
      final original = Review(
        id: '1',
        userId: '1',
        movieId: '1',
        rating: 8,
        comment: 'Great movie!',
      );
      final map = original.toMap();
      final restored = Review.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.rating, original.rating);
      expect(restored.comment, original.comment);
    });
  });

  group('Validators', () {
    test('validateRequired rejects empty string', () {
      expect(validateRequired(''), isNotNull);
      expect(validateRequired('   '), isNotNull);
      expect(validateRequired(null), isNotNull);
    });

    test('validateRequired accepts non-empty string', () {
      expect(validateRequired('hello'), isNull);
    });

    test('validatePositiveInt rejects non-positive', () {
      expect(validatePositiveInt('0'), isNotNull);
      expect(validatePositiveInt('-5'), isNotNull);
      expect(validatePositiveInt('abc'), isNotNull);
    });

    test('validatePositiveInt accepts positive', () {
      expect(validatePositiveInt('42'), isNull);
    });

    test('validatePositiveDouble rejects non-positive', () {
      expect(validatePositiveDouble('0'), isNotNull);
      expect(validatePositiveDouble('-1.5'), isNotNull);
    });

    test('validatePositiveDouble accepts positive', () {
      expect(validatePositiveDouble('3.14'), isNull);
    });

    test('validateIntInRange rejects out of range', () {
      expect(validateIntInRange('0', 1, 10), isNotNull);
      expect(validateIntInRange('11', 1, 10), isNotNull);
    });

    test('validateIntInRange accepts in range', () {
      expect(validateIntInRange('5', 1, 10), isNull);
    });

    test('validateDateTime rejects invalid format', () {
      expect(validateDateTime('not-a-date'), isNotNull);
      expect(validateDateTime('2026/05/07'), isNotNull);
    });

    test('validateDateTime accepts valid format', () {
      expect(validateDateTime('2026-05-07'), isNull);
      expect(validateDateTime('2026-05-07 14:30:00'), isNull);
    });

    test('validateNumericId rejects non-numeric', () {
      expect(validateNumericId(''), isNotNull);
      expect(validateNumericId('abc'), isNotNull);
      expect(validateNumericId('12a'), isNotNull);
      expect(validateNumericId('  '), isNotNull);
    });

    test('validateNumericId accepts numeric', () {
      expect(validateNumericId('123'), isNull);
      expect(validateNumericId('0'), isNull);
    });

    test('validateLength rejects out of range', () {
      expect(validateLength('ab', 3, 50, 'Имя'), isNotNull);
      expect(validateLength('', 3, 50, 'Имя'), isNotNull);
      expect(validateLength(null, 3, 50, 'Имя'), isNotNull);
    });

    test('validateLength accepts in range', () {
      expect(validateLength('Alice', 3, 50, 'Имя'), isNull);
      expect(validateLength('A', 1, 50, 'Имя'), isNull);
    });

    test('validateEmailAddress rejects invalid', () {
      expect(validateEmailAddress(''), isNotNull);
      expect(validateEmailAddress('not-email'), isNotNull);
      expect(validateEmailAddress('user@'), isNotNull);
    });

    test('validateEmailAddress accepts valid', () {
      expect(validateEmailAddress('user@example.com'), isNull);
      expect(validateEmailAddress('a@b.co'), isNull);
    });
  });

  group('Repository CRUD', () {
    late String dbPath;
    late AppDatabase db;
    late UserRepository userRepo;
    late MovieRepository movieRepo;
    late SubscriptionRepository subscriptionRepo;
    late ViewHistoryRepository viewHistoryRepo;
    late ReviewRepository reviewRepo;

    setUp(() {
      dbPath = p.join(
        Directory.systemTemp.path,
        'cinema_test_${DateTime.now().millisecondsSinceEpoch}.db',
      );
      db = AppDatabase(dbPath);
      userRepo = UserRepository(db);
      movieRepo = MovieRepository(db);
      subscriptionRepo = SubscriptionRepository(db);
      viewHistoryRepo = ViewHistoryRepository(db);
      reviewRepo = ReviewRepository(db);
    });

    tearDown(() {
      db.close();
      File(dbPath).deleteSync();
    });

    test('insert and read user', () {
      final user = CinemaUser(id: 'u1', name: 'Alice', email: 'alice@test.com');
      userRepo.insert(user);

      final users = userRepo.getAll();
      expect(users.length, 1);
      expect(users.first.name, 'Alice');

      final loaded = userRepo.getById('u1');
      expect(loaded, isNotNull);
      expect(loaded!.email, 'alice@test.com');
    });

    test('update user (INSERT OR REPLACE)', () {
      userRepo.insert(CinemaUser(id: 'u1', name: 'Alice', email: 'alice@test.com'));
      userRepo.insert(CinemaUser(id: 'u1', name: 'Alice Updated', email: 'alice.new@test.com'));
      final loaded = userRepo.getById('u1');
      expect(loaded!.name, 'Alice Updated');
      expect(loaded.email, 'alice.new@test.com');
    });

    test('delete user', () {
      userRepo.insert(CinemaUser(id: 'u2', name: 'Bob', email: 'bob@test.com'));
      expect(userRepo.getAll().length, 1);
      userRepo.delete('u2');
      expect(userRepo.getAll().length, 0);
    });

    test('insert and read movie', () {
      final movie = Movie(
        id: 'm1',
        title: 'The Matrix',
        genre: 'Action',
        durationMinutes: 136,
        releaseYear: 1999,
      );
      movieRepo.insert(movie);

      final movies = movieRepo.getAll();
      expect(movies.length, 1);
      expect(movies.first.title, 'The Matrix');
    });

    test('insert and read subscription', () {
      userRepo.insert(CinemaUser(id: 'u3', name: 'Charlie', email: 'c@test.com'));
      final sub = Subscription(
        id: 's1',
        userId: 'u3',
        type: 'monthly',
        price: 499.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 2, 1),
      );
      subscriptionRepo.insert(sub);

      final subs = subscriptionRepo.getAll();
      expect(subs.length, 1);
      expect(subs.first.type, 'monthly');
    });

    test('insert and read view history', () {
      userRepo.insert(CinemaUser(id: 'u4', name: 'Diana', email: 'd@test.com'));
      movieRepo.insert(Movie(
        id: 'm2',
        title: 'Test',
        genre: 'Drama',
        durationMinutes: 120,
        releaseYear: 2020,
      ));
      final vh = ViewHistory(
        id: 'v1',
        userId: 'u4',
        movieId: 'm2',
        watchDate: DateTime(2026, 5, 1, 14, 30),
        progressMinutes: 60,
      );
      viewHistoryRepo.insert(vh);

      final list = viewHistoryRepo.getAll();
      expect(list.length, 1);
      expect(list.first.progressMinutes, 60);
    });

    test('insert and read review', () {
      userRepo.insert(CinemaUser(id: 'u5', name: 'Eve', email: 'e@test.com'));
      movieRepo.insert(Movie(
        id: 'm3',
        title: 'Test',
        genre: 'Comedy',
        durationMinutes: 90,
        releaseYear: 2022,
      ));
      final review = Review(
        id: 'r1',
        userId: 'u5',
        movieId: 'm3',
        rating: 8,
        comment: 'Great movie!',
      );
      reviewRepo.insert(review);

      final reviews = reviewRepo.getAll();
      expect(reviews.length, 1);
      expect(reviews.first.rating, 8);
    });
  });

  group('dumpAllTables', () {
    late String dbPath;
    late AppDatabase db;
    late ReviewRepository reviewRepo;

    setUp(() {
      dbPath = p.join(
        Directory.systemTemp.path,
        'cinema_dump_test_${DateTime.now().millisecondsSinceEpoch}.db',
      );
      db = AppDatabase(dbPath);
      reviewRepo = ReviewRepository(db);
    });

    tearDown(() {
      db.close();
      File(dbPath).deleteSync();
    });

    test('returns all tables (even empty)', () {
      final dump = reviewRepo.dumpAllTables(db);
      expect(dump.keys, containsAll(['users', 'movies', 'subscriptions', 'view_history', 'reviews']));
      expect(dump['users'], isEmpty);
      expect(dump['movies'], isEmpty);
    });

    test('returns data after insertion', () {
      final userRepo = UserRepository(db);
      userRepo.insert(CinemaUser(id: 'u1', name: 'Test', email: 't@t.com'));
      final dump = reviewRepo.dumpAllTables(db);
      expect(dump['users']!.length, 1);
    });
  });
}
