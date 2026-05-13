import 'dart:io';

import '../data/database.dart';
import '../data/repositories/movie_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/view_history_repository.dart';
import '../domain/models/cinema_user.dart';
import '../domain/models/movie.dart';
import '../domain/models/review.dart';
import '../domain/models/subscription.dart';
import '../domain/models/view_history.dart';
import 'input_helper.dart';

void runMenu(AppDatabase db) {
  final userRepo = UserRepository(db);
  final movieRepo = MovieRepository(db);
  final subscriptionRepo = SubscriptionRepository(db);
  final viewHistoryRepo = ViewHistoryRepository(db);
  final reviewRepo = ReviewRepository(db);

  while (true) {
    stdout.writeln('''
Онлайн-кинотеатр

Пользователи:
  1 - список пользователей
  2 - добавить пользователя
  3 - удалить пользователя

Фильмы:
  4 - список фильмов
  5 - добавить фильм
  6 - удалить фильм

Подписки:
  7 - список подписок
  8 - добавить подписку
  9 - удалить подписку

История просмотров:
 10 - список истории просмотров
 11 - добавить запись просмотра
 12 - удалить запись просмотра

Отзывы:
 13 - список отзывов
 14 - добавить отзыв
 15 - удалить отзыв
 
 16 - показать всё из базы данных

Изменение:
 17 - изменить пользователя
 18 - изменить фильм
 19 - изменить подписку
 20 - изменить запись просмотра
 21 - изменить отзыв

 0 - выход

Выберите пункт меню:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _printUsers(userRepo);
      case '2':
        _addUser(userRepo);
      case '3':
        _deleteUser(userRepo);
      case '4':
        _printMovies(movieRepo);
      case '5':
        _addMovie(movieRepo);
      case '6':
        _deleteMovie(movieRepo);
      case '7':
        _printSubscriptions(subscriptionRepo);
      case '8':
        _addSubscription(subscriptionRepo, userRepo);
      case '9':
        _deleteSubscription(subscriptionRepo);
      case '10':
        _printViewHistory(viewHistoryRepo);
      case '11':
        _addViewHistory(viewHistoryRepo, userRepo, movieRepo);
      case '12':
        _deleteViewHistory(viewHistoryRepo);
      case '13':
        _printReviews(reviewRepo);
      case '14':
        _addReview(reviewRepo, userRepo, movieRepo);
      case '15':
        _deleteReview(reviewRepo);
      case '16':
        _printAllFromDb(db, reviewRepo);
      case '17':
        _editUser(userRepo);
      case '18':
        _editMovie(movieRepo);
      case '19':
        _editSubscription(subscriptionRepo, userRepo);
      case '20':
        _editViewHistory(viewHistoryRepo, userRepo, movieRepo);
      case '21':
        _editReview(reviewRepo, userRepo, movieRepo);
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
    stdout.writeln();
  }
}

void _printUsers(UserRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Нет пользователей.');
    return;
  }
  for (final u in list) {
    stdout.writeln('ID: ${u.id} | Имя: ${u.name} | Email: ${u.email}');
  }
}

void _printMovies(MovieRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Нет фильмов.');
    return;
  }
  for (final m in list) {
    stdout.writeln(
      'ID: ${m.id} | ${m.title} | ${m.genre} | ${m.durationMinutes} мин | ${m.releaseYear} г.',
    );
  }
}

void _printSubscriptions(SubscriptionRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Нет подписок.');
    return;
  }
  for (final s in list) {
    stdout.writeln(
      'ID: ${s.id} | Пользователь: ${s.userId} | ${s.type} | ${s.price} руб | ${s.startDate.toLocal().toIso8601String().substring(0, 10)} — ${s.endDate.toLocal().toIso8601String().substring(0, 10)}',
    );
  }
}

void _printViewHistory(ViewHistoryRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Нет истории просмотров.');
    return;
  }
  for (final v in list) {
    stdout.writeln(
      'ID: ${v.id} | Пользователь: ${v.userId} | Фильм: ${v.movieId} | ${v.watchDate.toLocal()} | ${v.progressMinutes} мин',
    );
  }
}

void _printReviews(ReviewRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Нет отзывов.');
    return;
  }
  for (final r in list) {
    stdout.writeln(
      'ID: ${r.id} | Пользователь: ${r.userId} | Фильм: ${r.movieId} | ${r.rating}/10 | "${r.comment}"',
    );
  }
}

void _printAllFromDb(AppDatabase db, ReviewRepository reviewRepo) {
  final dump = reviewRepo.dumpAllTables(db);
  for (final table in dump.keys) {
    stdout.writeln('\n--- $table ---');
    final rows = dump[table]!;
    if (rows.isEmpty) {
      stdout.writeln('(пусто)');
    } else {
      for (final row in rows) {
        stdout.writeln(row.toString());
      }
    }
  }
}

void _addUser(UserRepository repo) {
  final id = readNumericId('ID пользователя: ');
  final name = readWithLength('Имя: ', 3, 50, 'Имя');
  final email = readEmail('Email: ');

  repo.insert(CinemaUser(id: id, name: name, email: email));
  stdout.writeln('Пользователь сохранён.');
}

void _deleteUser(UserRepository repo) {
  final id = readNumericId('ID пользователя для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если ID существовал в базе).');
}

void _addMovie(MovieRepository repo) {
  final id = readNumericId('ID фильма: ');
  final title = readWithLength('Название: ', 2, 100, 'Название');
  final genre = readWithLength('Жанр: ', 2, 50, 'Жанр');
  final duration = readPositiveInt('Длительность в минутах: ');
  final year = readIntInRange('Год выпуска (1895-2026): ', 1895, 2026);

  repo.insert(
    Movie(
      id: id,
      title: title,
      genre: genre,
      durationMinutes: duration,
      releaseYear: year,
    ),
  );
  stdout.writeln('Фильм сохранён.');
}

void _deleteMovie(MovieRepository repo) {
  final id = readNumericId('ID фильма для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если ID существовал в базе).');
}

void _addSubscription(SubscriptionRepository repo, UserRepository userRepo) {
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);

  final id = readNumericId('ID подписки: ');
  final userId = readNumericId('ID пользователя: ');
  final type = readWithLength('Тип (monthly/yearly): ', 2, 30, 'Тип');
  final price = readPositiveDouble('Цена: ');
  final startDate = readDateTime('Дата начала (YYYY-MM-DD): ');
  final endDate = readDateTime('Дата окончания (YYYY-MM-DD): ');

  repo.insert(
    Subscription(
      id: id,
      userId: userId,
      type: type,
      price: price,
      startDate: startDate,
      endDate: endDate,
    ),
  );
  stdout.writeln('Подписка сохранена.');
}

void _deleteSubscription(SubscriptionRepository repo) {
  final id = readNumericId('ID подписки для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если ID существовал в базе).');
}

void _addViewHistory(
    ViewHistoryRepository repo, UserRepository userRepo, MovieRepository movieRepo) {
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln('Доступные фильмы:');
  _printMovies(movieRepo);

  final id = readNumericId('ID записи просмотра: ');
  final userId = readNumericId('ID пользователя: ');
  final movieId = readNumericId('ID фильма: ');
  final watchDate = readDateTime('Дата и время просмотра (YYYY-MM-DD HH:MM): ');
  final progress = readPositiveInt('Просмотрено минут: ');

  repo.insert(
    ViewHistory(
      id: id,
      userId: userId,
      movieId: movieId,
      watchDate: watchDate,
      progressMinutes: progress,
    ),
  );
  stdout.writeln('Запись просмотра сохранена.');
}

void _deleteViewHistory(ViewHistoryRepository repo) {
  final id = readNumericId('ID записи просмотра для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если ID существовал в базе).');
}

void _addReview(
    ReviewRepository repo, UserRepository userRepo, MovieRepository movieRepo) {
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln('Доступные фильмы:');
  _printMovies(movieRepo);

  final id = readNumericId('ID отзыва: ');
  final userId = readNumericId('ID пользователя: ');
  final movieId = readNumericId('ID фильма: ');
  final rating = readIntInRange('Оценка (1-10): ', 1, 10);
  final comment = readWithLength('Комментарий: ', 1, 500, 'Комментарий');

  repo.insert(
    Review(
      id: id,
      userId: userId,
      movieId: movieId,
      rating: rating,
      comment: comment,
    ),
  );
  stdout.writeln('Отзыв сохранён.');
}

void _deleteReview(ReviewRepository repo) {
  final id = readNumericId('ID отзыва для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если ID существовал в базе).');
}

void _editUser(UserRepository repo) {
  final id = readNumericId('ID пользователя для изменения: ');
  final existing = repo.getById(id);
  if (existing == null) {
    stdout.writeln('Пользователь с ID $id не найден.');
    return;
  }
  stdout.writeln('Текущие данные: Имя: ${existing.name}, Email: ${existing.email}');
  final name = readOptional('Новое имя', existing.name);
  final email = readOptional('Новый email', existing.email);
  repo.insert(CinemaUser(id: id, name: name, email: email));
  stdout.writeln('Пользователь изменён.');
}

void _editMovie(MovieRepository repo) {
  final id = readNumericId('ID фильма для изменения: ');
  final existing = repo.getById(id);
  if (existing == null) {
    stdout.writeln('Фильм с ID $id не найден.');
    return;
  }
  stdout.writeln(
    'Текущие данные: ${existing.title}, ${existing.genre}, ${existing.durationMinutes} мин, ${existing.releaseYear} г.',
  );
  final title = readOptional('Новое название', existing.title);
  final genre = readOptional('Новый жанр', existing.genre);
  final duration = readOptionalInt('Новая длительность (мин)', existing.durationMinutes);
  final year = readOptionalInt('Новый год выпуска', existing.releaseYear);
  repo.insert(
    Movie(id: id, title: title, genre: genre, durationMinutes: duration, releaseYear: year),
  );
  stdout.writeln('Фильм изменён.');
}

void _editSubscription(SubscriptionRepository repo, UserRepository userRepo) {
  final id = readNumericId('ID подписки для изменения: ');
  final existing = repo.getById(id);
  if (existing == null) {
    stdout.writeln('Подписка с ID $id не найдена.');
    return;
  }
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln(
    'Текущие данные: пользователь ${existing.userId}, ${existing.type}, ${existing.price} руб',
  );
  final userId = readOptional('Новый ID пользователя', existing.userId);
  final type = readOptional('Новый тип', existing.type);
  final price = readOptionalDouble('Новая цена', existing.price);
  final startDate = readOptionalDateTime('Новая дата начала (YYYY-MM-DD)', existing.startDate);
  final endDate = readOptionalDateTime('Новая дата окончания (YYYY-MM-DD)', existing.endDate);
  repo.insert(
    Subscription(
      id: id,
      userId: userId,
      type: type,
      price: price,
      startDate: startDate,
      endDate: endDate,
    ),
  );
  stdout.writeln('Подписка изменена.');
}

void _editViewHistory(
    ViewHistoryRepository repo, UserRepository userRepo, MovieRepository movieRepo) {
  final id = readNumericId('ID записи просмотра для изменения: ');
  final existing = repo.getById(id);
  if (existing == null) {
    stdout.writeln('Запись с ID $id не найдена.');
    return;
  }
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln('Доступные фильмы:');
  _printMovies(movieRepo);
  stdout.writeln(
    'Текущие данные: пользователь ${existing.userId}, фильм ${existing.movieId}, ${existing.progressMinutes} мин',
  );
  final userId = readOptional('Новый ID пользователя', existing.userId);
  final movieId = readOptional('Новый ID фильма', existing.movieId);
  final watchDate = readOptionalDateTime(
    'Новая дата просмотра (YYYY-MM-DD HH:MM)',
    existing.watchDate,
  );
  final progress = readOptionalInt('Новое количество минут', existing.progressMinutes);
  repo.insert(
    ViewHistory(
      id: id,
      userId: userId,
      movieId: movieId,
      watchDate: watchDate,
      progressMinutes: progress,
    ),
  );
  stdout.writeln('Запись просмотра изменена.');
}

void _editReview(
    ReviewRepository repo, UserRepository userRepo, MovieRepository movieRepo) {
  final id = readNumericId('ID отзыва для изменения: ');
  final existing = repo.getById(id);
  if (existing == null) {
    stdout.writeln('Отзыв с ID $id не найден.');
    return;
  }
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln('Доступные фильмы:');
  _printMovies(movieRepo);
  stdout.writeln(
    'Текущие данные: пользователь ${existing.userId}, фильм ${existing.movieId}, ${existing.rating}/10, "${existing.comment}"',
  );
  final userId = readOptional('Новый ID пользователя', existing.userId);
  final movieId = readOptional('Новый ID фильма', existing.movieId);
  final rating = readOptionalInt('Новая оценка (1-10)', existing.rating);
  final comment = readOptional('Новый комментарий', existing.comment);
  repo.insert(
    Review(
      id: id,
      userId: userId,
      movieId: movieId,
      rating: rating,
      comment: comment,
    ),
  );
  stdout.writeln('Отзыв изменён.');
}
