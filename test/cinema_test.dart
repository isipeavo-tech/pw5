import 'package:online_cinema/online_cinema.dart';
import 'package:test/test.dart';

void main() {
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
}
