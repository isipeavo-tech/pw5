import 'package:online_cinema/online_cinema.dart';

void main(List<String> arguments) {
  final db = AppDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
