String? validateDateTime(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Введите дату и время.';
  }
  try {
    DateTime.parse(value.trim());
    return null;
  } on FormatException {
    return 'Неверный формат даты/времени. Используйте YYYY-MM-DD HH:MM или YYYY-MM-DDTHH:MM:SS.';
  }
}
