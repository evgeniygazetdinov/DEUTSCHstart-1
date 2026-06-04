import '../services/grammar_stats_service.dart';

/// Сохранить ответ из экрана упражнений в общую статистику.
Future<void> recordGrammarAnswer({
  required GrammarStatsModule module,
  required bool ok,
  required List<String> options,
  required int correctIndex,
}) {
  final tag =
      correctIndex >= 0 && correctIndex < options.length ? options[correctIndex] : null;
  return GrammarStatsService.instance.record(
    module: module,
    ok: ok,
    correctTag: tag,
  );
}
