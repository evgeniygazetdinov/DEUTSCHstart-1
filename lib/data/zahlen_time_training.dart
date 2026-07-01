import 'dart:math';

import '../utils/german_numbers.dart';

enum ZahlenPromptKind { number, clock, decimal, year }

class ZahlenTimeQuestion {
  const ZahlenTimeQuestion({
    required this.kind,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
    this.number,
    this.hour12,
    this.minute,
    this.decimalWhole,
    this.decimalFractional,
    this.decimalPlaces,
    this.year,
  });

  final ZahlenPromptKind kind;
  final int? number;
  final int? hour12;
  final int? minute;
  final int? decimalWhole;
  final int? decimalFractional;
  final int? decimalPlaces;
  final int? year;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;

  String get displayLabel => switch (kind) {
        ZahlenPromptKind.number => '${number!}',
        ZahlenPromptKind.clock => formatClockLabel(hour12!, minute!),
        ZahlenPromptKind.decimal => formatDecimalLabel(
            decimalWhole!,
            decimalFractional!,
            decimalPlaces!,
          ),
        ZahlenPromptKind.year => '${year!}',
      };
}

const sessionLength = 24;
const _minYear = 1950;
const _maxYear = 2030;

/// Одно случайное задание; [avoidLabels] — недавние подписи, чтобы не повторять подряд.
ZahlenTimeQuestion generateRandomZahlenQuestion(
  Random random, {
  Set<String> avoidLabels = const {},
}) {
  for (var attempt = 0; attempt < 40; attempt++) {
    final kind = ZahlenPromptKind.values[random.nextInt(ZahlenPromptKind.values.length)];
    final q = switch (kind) {
      ZahlenPromptKind.number => _numberQuestion(random),
      ZahlenPromptKind.clock => _clockQuestion(random),
      ZahlenPromptKind.decimal => _decimalQuestion(random),
      ZahlenPromptKind.year => _yearQuestion(random),
    };
    if (!avoidLabels.contains(q.displayLabel)) return q;
  }
  return _numberQuestion(random);
}

int _randomInteger(Random random) {
  final roll = random.nextInt(10);
  if (roll < 4) return random.nextInt(1000);
  if (roll < 7) return 100 + random.nextInt(900);
  if (roll < 9) return random.nextInt(100);
  return 10 + random.nextInt(990);
}

ZahlenTimeQuestion _numberQuestion(Random random) {
  final n = _randomInteger(random);
  final correct = numberToGermanWords(n);
  final options = _buildOptions(
    random: random,
    correct: correct,
    pool: _numberDistractorPool(n, random),
  );
  return ZahlenTimeQuestion(
    kind: ZahlenPromptKind.number,
    number: n,
    options: options.options,
    correctIndex: options.correctIndex,
    solutionDe: correct,
  );
}

ZahlenTimeQuestion _clockQuestion(Random random) {
  final hour = 1 + random.nextInt(12);
  final minute = random.nextInt(60);
  final correct = clockTimeToGermanWords(hour, minute);
  final pool = _timeDistractorPool(hour, minute, random);
  final options = _buildOptions(random: random, correct: correct, pool: pool);
  return ZahlenTimeQuestion(
    kind: ZahlenPromptKind.clock,
    hour12: hour,
    minute: minute,
    options: options.options,
    correctIndex: options.correctIndex,
    solutionDe: correct,
  );
}

ZahlenTimeQuestion _decimalQuestion(Random random) {
  final whole = _randomInteger(random).clamp(0, 999);
  if (random.nextBool()) {
    final fractional = 1 + random.nextInt(9);
    final correct = decimalToGermanWords(whole, fractional, 1);
    final pool = _decimalDistractorPool(whole, fractional, 1, random);
    final options = _buildOptions(random: random, correct: correct, pool: pool);
    return ZahlenTimeQuestion(
      kind: ZahlenPromptKind.decimal,
      decimalWhole: whole,
      decimalFractional: fractional,
      decimalPlaces: 1,
      options: options.options,
      correctIndex: options.correctIndex,
      solutionDe: correct,
    );
  }
  final fractional = 1 + random.nextInt(99);
  final correct = decimalToGermanWords(whole, fractional, 2);
  final pool = _decimalDistractorPool(whole, fractional, 2, random);
  final options = _buildOptions(random: random, correct: correct, pool: pool);
  return ZahlenTimeQuestion(
    kind: ZahlenPromptKind.decimal,
    decimalWhole: whole,
    decimalFractional: fractional,
    decimalPlaces: 2,
    options: options.options,
    correctIndex: options.correctIndex,
    solutionDe: correct,
  );
}

ZahlenTimeQuestion _yearQuestion(Random random) {
  final year = _minYear + random.nextInt(_maxYear - _minYear + 1);
  final correct = yearToGermanWords(year);
  final pool = _yearDistractorPool(year, random);
  final options = _buildOptions(random: random, correct: correct, pool: pool);
  return ZahlenTimeQuestion(
    kind: ZahlenPromptKind.year,
    year: year,
    options: options.options,
    correctIndex: options.correctIndex,
    solutionDe: correct,
  );
}

List<String> _numberDistractorPool(int n, Random random) {
  final pool = <String>{};
  var guard = 0;
  while (pool.length < 10 && guard++ < 40) {
    final delta = random.nextInt(61) - 30;
    if (delta == 0) continue;
    final v = n + delta;
    if (v < 0 || v > 999) continue;
    pool.add(numberToGermanWords(v));
  }
  return pool.toList();
}

List<String> _timeDistractorPool(int hour, int minute, Random random) {
  final pool = <String>{};
  var guard = 0;
  while (pool.length < 8 && guard++ < 30) {
    final h = 1 + random.nextInt(12);
    final m = random.nextInt(60);
    if (h == hour && m == minute) continue;
    pool.add(clockTimeToGermanWords(h, m));
  }
  return pool.toList();
}

List<String> _decimalDistractorPool(
  int whole,
  int fractional,
  int places,
  Random random,
) {
  final pool = <String>{};
  var guard = 0;
  while (pool.length < 8 && guard++ < 30) {
    final w = (whole + random.nextInt(21) - 10).clamp(0, 999);
    final f = places == 1
        ? 1 + random.nextInt(9)
        : 1 + random.nextInt(99);
    if (w == whole && f == fractional) continue;
    pool.add(decimalToGermanWords(w, f, places));
  }
  return pool.toList();
}

List<String> _yearDistractorPool(int year, Random random) {
  final pool = <String>{};
  var guard = 0;
  while (pool.length < 8 && guard++ < 30) {
    final y = year + random.nextInt(21) - 10;
    if (y < _minYear || y > _maxYear || y == year) continue;
    pool.add(yearToGermanWords(y));
  }
  return pool.toList();
}

({List<String> options, int correctIndex}) _buildOptions({
  required Random random,
  required String correct,
  required List<String> pool,
}) {
  final wrong = pool.where((w) => w != correct).toSet().toList()..shuffle(random);
  final picks = wrong.take(2).toList();
  var guard = 0;
  while (picks.length < 2 && guard++ < 30) {
    final extra = numberToGermanWords(_randomInteger(random).clamp(0, 999));
    if (extra != correct && !picks.contains(extra)) {
      picks.add(extra);
    }
  }
  final options = [correct, ...picks]..shuffle(random);
  return (options: options, correctIndex: options.indexOf(correct));
}

int get zahlenTimeSessionLength => sessionLength;
