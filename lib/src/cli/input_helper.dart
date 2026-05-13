import 'dart:io';

import '../domain/validators/date_validator.dart';
import '../domain/validators/number_validator.dart';
import '../domain/validators/text_validator.dart';

String readRequired(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync()?.trim() ?? '';
    final error = validateRequired(value);
    if (error == null) return value;
    stdout.writeln('Ошибка: $error');
  }
}

double readPositiveDouble(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    final error = validatePositiveDouble(input);
    if (error == null) return double.parse(input.replaceAll(',', '.'));
    stdout.writeln('Ошибка: $error');
  }
}

int readPositiveInt(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    final error = validatePositiveInt(input);
    if (error == null) return int.parse(input);
    stdout.writeln('Ошибка: $error');
  }
}

int readIntInRange(String label, int min, int max) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    final error = validateIntInRange(input, min, max);
    if (error == null) return int.parse(input);
    stdout.writeln('Ошибка: $error');
  }
}

DateTime readDateTime(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    final error = validateDateTime(input);
    if (error == null) return DateTime.parse(input);
    stdout.writeln('Ошибка: $error');
  }
}

String readNumericId(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync()?.trim() ?? '';
    final error = validateNumericId(value);
    if (error == null) return value;
    stdout.writeln('Ошибка: $error');
  }
}

String readWithLength(String label, int min, int max, String fieldName) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync()?.trim() ?? '';
    final error = validateLength(value, min, max, fieldName);
    if (error == null) return value;
    stdout.writeln('Ошибка: $error');
  }
}

String readEmail(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync()?.trim() ?? '';
    final error = validateEmailAddress(value);
    if (error == null) return value;
    stdout.writeln('Ошибка: $error');
  }
}

String readOptional(String label, String currentValue) {
  stdout.write('$label [$currentValue]: ');
  final value = stdin.readLineSync()?.trim() ?? '';
  return value.isEmpty ? currentValue : value;
}

int readOptionalInt(String label, int currentValue) {
  stdout.write('$label [$currentValue]: ');
  final value = stdin.readLineSync()?.trim() ?? '';
  if (value.isEmpty) return currentValue;
  final parsed = int.tryParse(value);
  if (parsed != null) return parsed;
  return currentValue;
}

double readOptionalDouble(String label, double currentValue) {
  stdout.write('$label [$currentValue]: ');
  final value = stdin.readLineSync()?.trim() ?? '';
  if (value.isEmpty) return currentValue;
  final parsed = double.tryParse(value.replaceAll(',', '.'));
  if (parsed != null && parsed > 0) return parsed;
  return currentValue;
}

DateTime readOptionalDateTime(String label, DateTime currentValue) {
  stdout.write('$label [${currentValue.toIso8601String().substring(0, 10)}]: ');
  final value = stdin.readLineSync()?.trim() ?? '';
  if (value.isEmpty) return currentValue;
  try {
    return DateTime.parse(value);
  } on FormatException {
    return currentValue;
  }
}
