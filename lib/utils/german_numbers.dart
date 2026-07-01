/// Немецкие числительные и формулировки времени (A1).
library;

const _basic = [
  'null',
  'eins',
  'zwei',
  'drei',
  'vier',
  'fünf',
  'sechs',
  'sieben',
  'acht',
  'neun',
  'zehn',
  'elf',
  'zwölf',
];
const _teens = [
  'zehn',
  'elf',
  'zwölf',
  'dreizehn',
  'vierzehn',
  'fünfzehn',
  'sechzehn',
  'siebzehn',
  'achtzehn',
  'neunzehn',
];
const _tens = [
  '',
  '',
  'zwanzig',
  'dreißig',
  'vierzig',
  'fünfzig',
  'sechzig',
  'siebzig',
  'achtzig',
  'neunzig',
];
const _onesCompound = [
  '',
  'ein',
  'zwei',
  'drei',
  'vier',
  'fünf',
  'sechs',
  'sieben',
  'acht',
  'neun',
];

/// Число 0–999 словами (кардинальное).
String numberToGermanWords(int n) {
  if (n < 0 || n > 999) {
    throw ArgumentError.value(n, 'n', 'expected 0..999');
  }
  if (n <= 12) return _basic[n];
  if (n < 20) return _teens[n - 10];
  if (n < 100) {
    final ones = n % 10;
    final tens = n ~/ 10;
    if (ones == 0) return _tens[tens];
    return '${_onesCompound[ones]}und${_tens[tens]}';
  }
  final hundreds = n ~/ 100;
  final rest = n % 100;
  final prefix = hundreds == 1 ? 'ein' : _onesCompound[hundreds];
  if (rest == 0) return '${prefix}hundert';
  return '${prefix}hundert${numberToGermanWords(rest)}';
}

/// Год (1100–2099): «neunzehnhundertfünfundachtzig», «zweitausendvierundzwanzig».
String yearToGermanWords(int year) {
  if (year < 1100 || year > 2099) {
    throw ArgumentError.value(year, 'year', 'expected 1100..2099');
  }
  if (year < 2000) {
    final century = year ~/ 100;
    final rest = year % 100;
    final centuryWord = numberToGermanWords(century);
    if (rest == 0) return '${centuryWord}hundert';
    return '${centuryWord}hundert${numberToGermanWords(rest)}';
  }
  final rest = year % 1000;
  if (rest == 0) return 'zweitausend';
  return 'zweitausend${numberToGermanWords(rest)}';
}

/// Десятичное число: 12,45 → «zwölf Komma fünfundvierzig», 3,05 → «drei Komma null fünf».
String decimalToGermanWords(int whole, int fractional, int decimalPlaces) {
  if (whole < 0 || whole > 999) {
    throw ArgumentError.value(whole, 'whole', 'expected 0..999');
  }
  if (fractional <= 0 || decimalPlaces <= 0) {
    throw ArgumentError('fractional part required');
  }
  final wholeWord = numberToGermanWords(whole);
  final fracWord = _fractionalToGermanWords(fractional, decimalPlaces);
  return '$wholeWord Komma $fracWord';
}

String _fractionalToGermanWords(int fractional, int decimalPlaces) {
  if (decimalPlaces == 2 && fractional < 10) {
    return 'null ${numberToGermanWords(fractional)}';
  }
  if (decimalPlaces == 1) {
    return numberToGermanWords(fractional);
  }
  // Две цифры после запятой, но без ведущего нуля (10–99).
  return numberToGermanWords(fractional);
}

/// Подпись для карточки: «12,45».
String formatDecimalLabel(int whole, int fractional, int decimalPlaces) {
  if (decimalPlaces == 1) {
    return '$whole,${fractional}';
  }
  return '$whole,${fractional.toString().padLeft(2, '0')}';
}

/// Время на циферблате (1–12 ч, 0–59 мин) по-немецки: «drei Uhr fünfzehn».
String clockTimeToGermanWords(int hour12, int minute) {
  final h = hour12.clamp(1, 12);
  final m = minute.clamp(0, 59);
  final hourWord = numberToGermanWords(h);
  if (m == 0) return '$hourWord Uhr';
  return '$hourWord Uhr ${numberToGermanWords(m)}';
}

/// Цифровое время 0–23 ч, 0–59 мин.
String digitalTimeToGermanWords(int hour24, int minute) {
  final h = hour24.clamp(0, 23);
  final m = minute.clamp(0, 59);
  final hourWord = numberToGermanWords(h);
  if (m == 0) return '$hourWord Uhr';
  return '$hourWord Uhr ${numberToGermanWords(m)}';
}

/// Формат HH:MM для подписи под циферблатом.
String formatClockLabel(int hour12, int minute) {
  final h = hour12.clamp(1, 12);
  final m = minute.clamp(0, 59);
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}
