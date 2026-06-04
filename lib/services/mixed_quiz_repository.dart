import 'dart:math';

import '../data/mixed_quiz_models.dart';
import '../data/mixed_quiz_pool.dart';
import 'grammar_stats_service.dart';

class MixedQuizRepository {
  MixedQuizRepository._();
  static final MixedQuizRepository instance = MixedQuizRepository._();

  static const sessionSize = 30;

  List<MixedQuizItem>? _pool;

  List<MixedQuizItem> get pool => _pool ??= loadMixedQuizPool();

  int get poolSize => pool.length;

  /// 30 случайных карточек из всего пула (~1200+ по всем рубрикам).
  Future<List<MixedQuizItem>> pickSessionQuestions(Random rng) async {
    final full = List<MixedQuizItem>.from(pool);
    full.shuffle(rng);
    if (full.length <= sessionSize) return full;
    return full.sublist(0, sessionSize);
  }

  Future<void> recordAnswer(MixedQuizItem q, bool ok) async {
    final mod = GrammarStatsService.fromMixedQuiz(q.module);
    if (mod != null) {
      final tag = q.options[q.correctIndex];
      await GrammarStatsService.instance.record(
        module: mod,
        ok: ok,
        correctTag: tag,
      );
    }
    await GrammarStatsService.instance.record(
      module: GrammarStatsModule.mix,
      ok: ok,
      correctTag: q.options[q.correctIndex],
    );
  }
}
