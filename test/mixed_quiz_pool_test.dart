import 'package:flutter_test/flutter_test.dart';
import 'package:test_deutsch_start/data/mixed_quiz_models.dart';
import 'package:test_deutsch_start/data/mixed_quiz_pool.dart';

void main() {
  test('every pool item has non-empty questionDisplay', () {
    final pool = loadMixedQuizPool();
    expect(pool.length, greaterThan(100));
    for (final q in pool) {
      expect(
        q.questionDisplay.trim().isNotEmpty,
        isTrue,
        reason: '${q.module} #${q.sourceNr}',
      );
    }
  });

  test('der/die/das items show noun in questionDisplay', () {
    final pool = loadMixedQuizPool();
    final d = pool.firstWhere((q) => q.module == MixedQuizModule.derDieDas);
    expect(d.afterGap.trim(), isNotEmpty);
    expect(d.questionDisplay, d.afterGap.trim());
  });
}
