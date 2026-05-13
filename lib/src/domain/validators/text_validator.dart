String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Поле не может быть пустым.';
  }
  return null;
}

String? validateNumericId(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'ID не может быть пустым.';
  }
  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
    return 'ID должно содержать только цифры.';
  }
  return null;
}

String? validateLength(String? value, int min, int max, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName не может быть пустым.';
  }
  final trimmed = value.trim();
  if (trimmed.length < min || trimmed.length > max) {
    return '$fieldName должно быть от $min до $max символов.';
  }
  return null;
}

String? validateEmailAddress(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email не может быть пустым.';
  }
  final trimmed = value.trim();
  if (!trimmed.contains('@') || !trimmed.contains('.')) {
    return 'Введите корректный email (например, user@example.com).';
  }
  return null;
}
