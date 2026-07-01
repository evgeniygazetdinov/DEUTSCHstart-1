import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/zahlen_time_theory.dart';
import '../../data/zahlen_time_training.dart';
import '../../l10n/app_strings.dart';
import '../../l10n/app_locale_scope.dart';
import '../../services/german_word_tts.dart';
import '../../services/grammar_stats_service.dart';
import '../../utils/artikel_stats_feedback.dart';
import '../../utils/record_grammar_answer.dart';
import '../../widgets/analog_clock_face.dart';
import '../../widgets/language_switch_button.dart';
import '../../widgets/theory_tab_content.dart';

/// Тренировка: число или циферблат → выбор немецкого варианта (3 ответа).
class ZahlenUhrzeitScreen extends StatefulWidget {
  const ZahlenUhrzeitScreen({super.key});

  @override
  State<ZahlenUhrzeitScreen> createState() => _ZahlenUhrzeitScreenState();
}

class _ZahlenUhrzeitScreenState extends State<ZahlenUhrzeitScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late int _zielAnzahl;
  final Random _random = Random();
  final List<ZahlenTimeQuestion> _retryQueue = [];
  final Set<String> _recentLabels = {};
  ZahlenTimeQuestion? _current;
  int _newQuestionsLeft = sessionLength;
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;

  bool get _atEnd => _current == null;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(_onTabChanged);
    _startNewSession();
  }

  void _onTabChanged() {
    if (_tabs.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    super.dispose();
  }

  void _startNewSession() {
    GermanWordTts.instance.stop();
    _zielAnzahl = sessionLength;
    _newQuestionsLeft = sessionLength;
    _retryQueue.clear();
    _recentLabels.clear();
    _picked = null;
    _showResult = false;
    _richtig = 0;
    _falsch = 0;
    _current = _takeNextQuestion();
  }

  ZahlenTimeQuestion? _takeNextQuestion() {
    if (_newQuestionsLeft <= 0 && _retryQueue.isEmpty) return null;

    ZahlenTimeQuestion q;
    if (_retryQueue.isNotEmpty &&
        (_newQuestionsLeft <= 0 || _random.nextBool())) {
      q = _retryQueue.removeAt(_random.nextInt(_retryQueue.length));
    } else {
      q = generateRandomZahlenQuestion(_random, avoidLabels: _recentLabels);
      _newQuestionsLeft--;
      _rememberLabel(q.displayLabel);
    }
    return q;
  }

  void _rememberLabel(String label) {
    _recentLabels.add(label);
    if (_recentLabels.length > 12) {
      _recentLabels.remove(_recentLabels.first);
    }
  }

  void _reshuffle() {
    setState(_startNewSession);
  }

  void _speakSolution() {
    final q = _current;
    if (q == null) return;
    GermanWordTts.instance.speak(q.solutionDe);
  }

  void _pick(int i) {
    if (_showResult || _current == null) return;
    final q = _current!;
    final ok = i == q.correctIndex;
    recordGrammarAnswer(
      module: GrammarStatsModule.zahlenUhrzeit,
      ok: ok,
      options: q.options,
      correctIndex: q.correctIndex,
    );
    setState(() {
      _picked = i;
      _showResult = true;
      if (ok) {
        _richtig++;
      } else {
        _falsch++;
      }
    });
  }

  void _next() {
    if (!_showResult || _current == null) return;
    GermanWordTts.instance.stop();
    final q = _current!;
    final wasCorrect = _picked == q.correctIndex;
    setState(() {
      if (!wasCorrect) {
        if (_retryQueue.isEmpty) {
          _retryQueue.add(q);
        } else {
          final pos = _random.nextInt(_retryQueue.length + 1);
          _retryQueue.insert(pos, q);
        }
      }
      _current = _takeNextQuestion();
      _picked = null;
      _showResult = false;
    });
  }

  String _weiterButtonLabel(BuildContext context) {
    final s = context.s;
    if (_current == null) return s.fertig;
    final left = _retryQueue.length + _newQuestionsLeft + 1;
    if (left <= 1 && _showResult && _picked == _current!.correctIndex) {
      return s.fertig;
    }
    return s.weiterNoch(left);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final scheme = Theme.of(context).colorScheme;
    final onUebungen = _tabs.index == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.zahlenUhrzeitAppBar),
        actions: [
          const LanguageSwitchButton(),
          if (onUebungen)
            IconButton(
              tooltip: s.shuffleTooltip,
              onPressed: _reshuffle,
              icon: const Icon(Icons.shuffle_rounded),
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: s.theoryTab),
            Tab(text: s.uebungenTab(_zielAnzahl)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildTheoryTab(context),
          SafeArea(
            child: _atEnd
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: _buildDone(context),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: _buildQuestion(context, scheme),
                        ),
                      ),
                      if (_showResult)
                        Material(
                          elevation: 6,
                          color: scheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _next,
                                child: Text(_weiterButtonLabel(context)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheoryTab(BuildContext context) {
    return TheoryTabContent(
      headline: 'Zahlen · Uhrzeit',
      intro: context.s.zahlenUhrzeitTheoryIntro,
      sections: kZahlenTimeTheorySections,
    );
  }

  Widget _buildDone(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = artikelAntwortProzent(_richtig, _falsch) ?? 0;
    final fb = context.s.artikelFeedback(p, ArtikelStatsModul.nominativDerDieDas);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.s.allFragenDone(_zielAnzahl),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  context.s.statsLine(_richtig, _falsch),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  fb.sterne,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  fb.meldung,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  context.s.shuffleHintArtikel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, ColorScheme scheme) {
    final q = _current!;
    final correct = _picked == q.correctIndex;
    final s = context.s;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          s.zahlenUhrzeitExerciseHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: (_richtig / _zielAnzahl).clamp(0.0, 1.0),
        ),
        const SizedBox(height: 8),
        Text(
          s.statsLine(_richtig, _falsch),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFD6EBFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF007AFF), width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                _promptForKind(s, q.kind),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C3C43),
                ),
              ),
              const SizedBox(height: 16),
              if (q.kind == ZahlenPromptKind.clock) ...[
                AnalogClockFace(
                  hour12: q.hour12!,
                  minute: q.minute!,
                  size: 200,
                ),
                const SizedBox(height: 8),
                Text(
                  q.displayLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C3C43),
                  ),
                ),
              ] else
                Text(
                  q.displayLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: q.kind == ZahlenPromptKind.year ? 48 : 56,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: const Color(0xFF000000),
                  ),
                ),
              if (_showResult) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        correct ? s.correctLabel : s.incorrectLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: correct
                              ? Colors.green.shade700
                              : scheme.error,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _speakSolution,
                      icon: const Icon(Icons.volume_up_rounded, size: 20),
                      label: Text(s.listenHortext),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  q.solutionDe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          s.antwort,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < q.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _optionTile(
              context: context,
              index: i,
              label: q.options[i],
              scheme: scheme,
              selected: _picked == i,
              showResult: _showResult,
              isCorrect: i == q.correctIndex,
              enabled: !_showResult,
              onTap: () => _pick(i),
            ),
          ),
      ],
    );
  }

  Widget _optionTile({
    required BuildContext context,
    required int index,
    required String label,
    required ColorScheme scheme,
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

    return Material(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${String.fromCharCode(65 + index)})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _promptForKind(AppStrings s, ZahlenPromptKind kind) => switch (kind) {
        ZahlenPromptKind.number => s.zahlenPromptNumber,
        ZahlenPromptKind.clock => s.zahlenPromptClock,
        ZahlenPromptKind.decimal => s.zahlenPromptDecimal,
        ZahlenPromptKind.year => s.zahlenPromptYear,
      };
}
