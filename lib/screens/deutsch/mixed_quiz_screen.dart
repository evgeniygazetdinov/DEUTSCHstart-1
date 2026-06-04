import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/mixed_quiz_models.dart';
import '../../l10n/app_locale.dart';
import '../../l10n/app_locale_scope.dart';
import '../../services/grammar_stats_service.dart';
import '../../services/mixed_quiz_repository.dart';
import '../../theme/apple_theme.dart';
import '../../widgets/language_switch_button.dart';
import '../../widgets/module_stats_bar.dart';

enum _MixedPhase { intro, loading, playing, finished }

/// 30 случайных вопросов из всего грамматического пула; общая статистика.
class MixedQuizScreen extends StatefulWidget {
  const MixedQuizScreen({super.key});

  @override
  State<MixedQuizScreen> createState() => _MixedQuizScreenState();
}

class _MixedQuizScreenState extends State<MixedQuizScreen> {
  final Random _random = Random();
  _MixedPhase _phase = _MixedPhase.intro;
  List<MixedQuizItem>? _queue;
  GrammarStatsState? _stats;
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;
  final Map<MixedQuizModule, int> _sessionWrongByModule = {};

  static const int _kTotal = MixedQuizRepository.sessionSize;

  bool get _atEnd => _queue != null && _queue!.isEmpty;
  MixedQuizItem? get _current =>
      (_queue != null && _queue!.isNotEmpty) ? _queue!.first : null;

  bool _isDerDieDasCard(MixedQuizItem q) =>
      q.module == MixedQuizModule.derDieDas;

  String _sentencePreview(MixedQuizItem q) {
    if (_isDerDieDasCard(q)) return q.questionDisplay;
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = ' $mid ';
    return '${q.beforeGap}$gap${q.afterGap}'.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _appBarQuestionLine(MixedQuizItem q) {
    final s = _sentencePreview(q);
    return s.isNotEmpty ? s : q.solutionDe;
  }

  static const _questionPanelStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: Color(0xFF000000),
    decoration: TextDecoration.none,
  );

  static const _nounPanelStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.15,
    color: Color(0xFF000000),
    decoration: TextDecoration.none,
  );

  Future<void> _loadStats() async {
    final st = await GrammarStatsService.instance.load();
    if (!mounted) return;
    setState(() => _stats = st);
  }

  Future<void> _startSession() async {
    setState(() {
      _phase = _MixedPhase.loading;
      _sessionWrongByModule.clear();
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
    final list =
        await MixedQuizRepository.instance.pickSessionQuestions(_random);
    if (!mounted) return;
    setState(() {
      _queue = list;
      _phase = _MixedPhase.playing;
    });
  }

  Future<void> _select(int i) async {
    if (_showResult || _current == null) return;
    final q = _current!;
    final ok = i == q.correctIndex;
    await MixedQuizRepository.instance.recordAnswer(q, ok);
    if (!mounted) return;
    setState(() {
      _picked = i;
      _showResult = true;
      if (ok) {
        _richtig++;
      } else {
        _falsch++;
        _sessionWrongByModule[q.module] =
            (_sessionWrongByModule[q.module] ?? 0) + 1;
      }
    });
  }

  void _nextQ() {
    if (_current == null) return;
    final q = _queue!.first;
    final wasCorrect = _picked == q.correctIndex;
    var finished = false;
    setState(() {
      _queue!.removeAt(0);
      if (!wasCorrect) {
        if (_queue!.isEmpty) {
          _queue!.add(q);
        } else {
          final pos = 1 + _random.nextInt(_queue!.length);
          _queue!.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
      if (_queue!.isEmpty) {
        _phase = _MixedPhase.finished;
        finished = true;
      }
    });
    if (finished) _loadStats();
  }

  String _weiterLabel(BuildContext context) {
    final s = context.s;
    if (_queue == null || _queue!.isEmpty) return s.weiter();
    final q = _queue!.first;
    if (_queue!.length == 1 && _showResult && _picked == q.correctIndex) {
      return s.fertig;
    }
    return s.weiter();
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = context.s;
    final playing = _phase == _MixedPhase.playing && _current != null;

    return Scaffold(
      backgroundColor: AppleTheme.groupedBackground,
      appBar: AppBar(
        title: Text(
          s.mixAppBar,
          style: const TextStyle(color: Color(0xFF000000)),
        ),
        bottom: playing
            ? PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  color: AppleTheme.groupedBackground,
                  child: Text(
                    _appBarQuestionLine(_current!),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              )
            : null,
        actions: const [LanguageSwitchButton()],
      ),
      body: switch (_phase) {
        _MixedPhase.intro => _buildIntro(context, scheme),
        _MixedPhase.loading => const Center(child: CircularProgressIndicator()),
        _MixedPhase.playing => _buildPlaying(context, scheme),
        _MixedPhase.finished => _buildFinished(context, scheme),
      },
    );
  }

  Widget _buildIntro(BuildContext context, ColorScheme scheme) {
    final s = context.s;
    final stats = _stats;
    final poolSize = MixedQuizRepository.instance.poolSize;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          s.mixTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          s.mixIntro,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 8),
        Text(
          _ru(context)
              ? 'В пуле сейчас $poolSize карточек.'
              : 'Pool size: $poolSize cards.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          s.mixCumulativeTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (stats == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!_hasAnyMixModuleStats(stats))
          Text(
            s.mixNoData,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final m in MixedQuizModule.values)
                if (_moduleStatsBar(context, stats, m) case final bar?) bar,
            ],
          ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _startSession,
          icon: const Icon(Icons.play_arrow),
          label: Text(s.mixStartButton),
        ),
      ],
    );
  }

  bool _ru(BuildContext context) =>
      context.localeController.language == AppLanguage.ru;

  Widget? _moduleStatsBar(
    BuildContext context,
    GrammarStatsState stats,
    MixedQuizModule m,
  ) {
    final gs = GrammarStatsService.fromMixedQuiz(m);
    if (gs == null) return null;
    final st = stats.modules[gs];
    if (st == null || st.total == 0) return null;
    final s = context.s;
    final pct = (st.accuracy * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ModuleStatsBar(
        stats: st,
        label: s.mixedQuizModuleLabel(m),
        answersLabel: s.moduleAnswersLine(st.total, pct),
      ),
    );
  }

  bool _hasAnyMixModuleStats(GrammarStatsState stats) {
    for (final m in MixedQuizModule.values) {
      final gs = GrammarStatsService.fromMixedQuiz(m);
      if (gs == null) continue;
      if ((stats.modules[gs]?.total ?? 0) > 0) return true;
    }
    return false;
  }

  Widget _questionPanel(BuildContext context, MixedQuizItem q) {
    final s = context.s;
    final isNoun = _isDerDieDasCard(q);
    final text = isNoun ? q.questionDisplay : _sentencePreview(q);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFD6EBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF007AFF), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isNoun)
            Text(
              s.welcherArtikel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C3C43),
              ),
              textAlign: TextAlign.center,
            ),
          if (isNoun) const SizedBox(height: 12),
          Text(
            text,
            textAlign: isNoun ? TextAlign.center : TextAlign.start,
            style: isNoun ? _nounPanelStyle : _questionPanelStyle,
          ),
        ],
      ),
    );
  }

  Widget _answerTile({
    required BuildContext context,
    required ColorScheme scheme,
    required int index,
    required String label,
    required bool selected,
    required bool showResult,
    required bool isCorrect,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    Color? border;
    Color? bg;
    if (showResult) {
      if (isCorrect) {
        border = Colors.green.shade600;
        bg = Colors.green.shade50;
      } else if (selected && !isCorrect) {
        border = scheme.error;
        bg = scheme.errorContainer.withValues(alpha: 0.35);
      }
    } else if (selected) {
      border = scheme.primary;
      bg = scheme.primaryContainer.withValues(alpha: 0.5);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg ?? scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: border ?? scheme.outlineVariant,
                width: border != null ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaying(BuildContext context, ColorScheme scheme) {
    if (_atEnd || _current == null) {
      return const SizedBox.shrink();
    }
    final s = context.s;
    final q = _current!;
    final correct = _picked == q.correctIndex;

    final useTiles = q.options.length <= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_richtig / _kTotal).clamp(0.0, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            s.statsLineRemaining(_richtig, _falsch, _queue!.length),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(s.mixChipLabel(
                mixedQuizModuleLabelDe(q.module),
                q.sourceNr,
                _queue!.length,
              )),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: _questionPanel(context, q),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text(
            s.choosePrompt,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              if (useTiles)
                for (var i = 0; i < q.options.length; i++)
                  _answerTile(
                    context: context,
                    scheme: scheme,
                    index: i,
                    label: q.options[i],
                    selected: _picked == i,
                    showResult: _showResult,
                    isCorrect: i == q.correctIndex,
                    enabled: !_showResult,
                    onTap: () => _select(i),
                  )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < q.options.length; i++)
                      ChoiceChip(
                        label: Text(
                          q.options[i],
                          style: const TextStyle(color: Color(0xFF000000)),
                        ),
                        selected: _picked == i,
                        onSelected: _showResult ? null : (_) => _select(i),
                      ),
                  ],
                ),
              if (_showResult) ...[
                const SizedBox(height: 16),
                Text(
                  correct ? s.correctLabel : s.incorrectLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: correct ? Colors.green.shade700 : scheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.solutionLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  q.solutionDe,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_showResult)
          Material(
            elevation: 8,
            color: scheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _nextQ,
                    child: Text(_weiterLabel(context)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFinished(BuildContext context, ColorScheme scheme) {
    final s = context.s;
    final p = _richtig + _falsch == 0
        ? 0
        : ((_richtig * 100) / (_richtig + _falsch)).round();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.check_circle_outline, size: 56, color: scheme.primary),
        const SizedBox(height: 16),
        Text(
          s.mixSessionDone,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          s.statsLineWithPercent(_richtig, _falsch, '$p%'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          s.sessionRecommendation(_sessionWrongByModule),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () {
            setState(() {
              _phase = _MixedPhase.intro;
              _queue = null;
            });
            _loadStats();
          },
          child: Text(s.mixBackToStart),
        ),
      ],
    );
  }
}
