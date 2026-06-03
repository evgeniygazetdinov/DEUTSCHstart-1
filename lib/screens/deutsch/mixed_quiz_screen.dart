import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/mixed_quiz_models.dart';
import '../../l10n/app_locale_scope.dart';
import '../../services/mixed_quiz_repository.dart';
import '../../widgets/language_switch_button.dart';

enum _MixedPhase { intro, loading, playing, finished }

/// 30 случайных вопросов из всех грамматических модулей; статистика и приоритет ошибок.
class MixedQuizScreen extends StatefulWidget {
  const MixedQuizScreen({super.key});

  @override
  State<MixedQuizScreen> createState() => _MixedQuizScreenState();
}

class _MixedQuizScreenState extends State<MixedQuizScreen> {
  final Random _random = Random();
  _MixedPhase _phase = _MixedPhase.intro;
  List<MixedQuizItem>? _queue;
  MixedQuizPersistentState? _cumulative;
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;
  final Map<MixedQuizModule, int> _sessionWrongByModule = {};

  static const int _kTotal = 30;

  bool get _atEnd => _queue != null && _queue!.isEmpty;
  MixedQuizItem? get _current =>
      (_queue != null && _queue!.isNotEmpty) ? _queue!.first : null;

  String _previewLine(MixedQuizItem q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
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
    final cum = await MixedQuizRepository.instance.loadState();
    if (!mounted) return;
    setState(() {
      _queue = list;
      _cumulative = cum;
      _phase = _MixedPhase.playing;
    });
  }

  Future<void> _reloadCumulative() async {
    final cum = await MixedQuizRepository.instance.loadState();
    if (!mounted) return;
    setState(() => _cumulative = cum);
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
    if (finished) {
      _reloadCumulative();
    }
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
    _reloadCumulative();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.mixAppBar),
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
    final cum = _cumulative;
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
        const SizedBox(height: 20),
        Text(
          s.mixCumulativeTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (cum == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final m in MixedQuizModule.values)
                    if ((cum.moduleStats[m]?.total ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          s.mixCumulativeLine(
                            m,
                            cum.moduleStats[m]!.right,
                            cum.moduleStats[m]!.wrong,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                  if (cum.moduleStats.values.every((st) => st.total == 0))
                    Text(
                      s.mixNoData,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                ],
              ),
            ),
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

  Widget _buildPlaying(BuildContext context, ColorScheme scheme) {
    if (_atEnd || _current == null) {
      return const SizedBox.shrink();
    }
    final s = context.s;
    final q = _current!;
    final correct = _picked == q.correctIndex;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_richtig / _kTotal).clamp(0.0, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              s.statsLineRemaining(_richtig, _falsch, _queue!.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              Chip(
                label: Text(
                  s.mixChipLabel(
                    mixedQuizModuleLabelDe(q.module),
                    q.sourceNr,
                    _queue!.length,
                  ),
                ),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    _previewLine(q),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.choosePrompt,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < q.options.length; i++)
                    ChoiceChip(
                      label: Text(q.options[i]),
                      selected: _picked == i,
                      onSelected: _showResult ? null : (_) => _select(i),
                    ),
                ],
              ),
              if (_showResult) ...[
                const SizedBox(height: 20),
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  q.solutionDe,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
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
            _reloadCumulative();
          },
          child: Text(s.mixBackToStart),
        ),
      ],
    );
  }
}
