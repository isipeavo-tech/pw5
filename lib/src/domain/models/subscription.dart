import 'identity.dart';

class Subscription implements Identity {
  Subscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
  });

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      price: _asDouble(map['price']),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }

  @override
  final String id;
  final String userId;
  final String type;
  final double price;
  final DateTime startDate;
  final DateTime endDate;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'type': type,
        'price': price,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  static double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    throw FormatException('Expected a number', value);
  }

  @override
  String toString() =>
      '$type — $price rub (${startDate.toLocal().toIso8601String().substring(0, 10)} — ${endDate.toLocal().toIso8601String().substring(0, 10)})';
}
