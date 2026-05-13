import '../../domain/models/subscription.dart';
import '../database.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._db);
  final AppDatabase _db;

  void insert(Subscription subscription) {
    _db.sqlite.execute(
      'INSERT OR REPLACE INTO subscriptions(id,userId,type,price,startDate,endDate) VALUES(?,?,?,?,?,?)',
      [
        subscription.id,
        subscription.userId,
        subscription.type,
        subscription.price,
        subscription.startDate.toIso8601String(),
        subscription.endDate.toIso8601String(),
      ],
    );
  }

  List<Subscription> getAll() {
    final rows = _db.sqlite.select(
      'SELECT id,userId,type,price,startDate,endDate FROM subscriptions',
    );
    return rows.map((row) => Subscription.fromMap(row)).toList();
  }

  Subscription? getById(String id) {
    final rows = _db.sqlite.select(
      'SELECT id,userId,type,price,startDate,endDate FROM subscriptions WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Subscription.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.sqlite.execute('DELETE FROM subscriptions WHERE id=?', [id]);
  }
}
