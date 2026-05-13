import 'identity.dart';

class CinemaUser implements Identity {
  CinemaUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CinemaUser.fromMap(Map<String, dynamic> map) {
    return CinemaUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  @override
  final String id;
  final String name;
  final String email;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
      };

  @override
  String toString() => '$name ($email)';
}
