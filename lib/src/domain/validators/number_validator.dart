String? validatePositiveInt(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Введите целое число больше 0.';
  }
  final parsed = int.tryParse(value.trim());
  if (parsed == null || parsed <= 0) {
    return 'Введите целое положительное число больше 0.';
  }
  return null;
}

String? validatePositiveDouble(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Введите число больше 0.';
  }
  final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
  if (parsed == null || parsed <= 0) {
    return 'Введите положительное число больше 0.';
  }
  return null;
}

String? validateIntInRange(String? value, int min, int max) {
  if (value == null || value.trim().isEmpty) {
    return 'Введите число от $min до $max.';
  }
  final parsed = int.tryParse(value.trim());
  if (parsed == null || parsed < min || parsed > max) {
    return 'Введите число от $min до $max.';
  }
  return null;
}
