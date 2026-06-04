import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/der_die_das_data.dart';
import '../../data/der_die_das_theory.dart';
import '../../services/german_word_tts.dart';
import '../../l10n/app_locale_scope.dart';
import '../../services/grammar_stats_service.dart';
import '../../utils/artikel_stats_feedback.dart';
import '../../utils/record_grammar_answer.dart';
import '../../widgets/language_switch_button.dart';
import '../../widgets/theory_tab_content.dart';

/// Теория + упражнение: артикль der / die / das для существительного.
class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen>
    with SingleTickerProviderStateMixin {
  static const _optLabels = ['der', 'die', 'das'];

  late TabController _tabs;
  late List<DerDieDasQuestion> _items;
  late int _zielAnzahl;
  final Random _random = Random();
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;

  bool get _atEnd => _items.isEmpty;

  DerDieDasQuestion? get _current => _atEnd ? null : _items.first;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(_onTabChanged);
    _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
    _zielAnzahl = _items.length;
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

  void _reshuffle() {
    GermanWordTts.instance.stop();
    setState(() {
      _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
      _zielAnzahl = _items.length;
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
  }

  void _speakPrompt() {
    final q = _current;
    if (q == null) return;
    final tts = derDieDasPromptForTts(q.prompt);
    GermanWordTts.instance.speak(tts);
  }

  void _speakFullAnswer() {
    final q = _current;
    if (q == null) return;
    GermanWordTts.instance.speak(q.fullAnswer);
  }

  void _pick(int i) {
    if (_showResult || _current == null) return;
    final q = _current!;
    final ok = i == q.correctIndex;
    recordGrammarAnswer(
      module: GrammarStatsModule.derDieDas,
      ok: ok,
      options: _optLabels,
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
    final q = _items.first;
    final wasCorrect = _picked == q.correctIndex;
    setState(() {
      _items.removeAt(0);
      if (!wasCorrect) {
        if (_items.isEmpty) {
          _items.add(q);
        } else {
          final pos = 1 + _random.nextInt(_items.length);
          _items.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
    });
  }

  String _weiterButtonLabel(BuildContext context) {
    final s = context.s;
    final q = _items.first;
    if (_items.length == 1 && _showResult && _picked == q.correctIndex) {
      return s.fertig;
    }
    return s.weiterNoch(_items.length);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final scheme = Theme.of(context).colorScheme;
    final onUebungen = _tabs.index == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.artikelAppBar),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: _atEnd
                  ? _buildDone(context)
                  : SingleChildScrollView(
                      child: _buildQuestion(context, scheme),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: onUebungen && !_atEnd && _showResult
          ? Material(
              elevation: 6,
              color: scheme.surface,
              child: SafeArea(
                top: false,
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
            )
          : null,
    );
  }

  Widget _buildTheoryTab(BuildContext context) {
    return TheoryTabContent(
      headline: 'der · die · das',
      intro: context.s.artikelTheoryIntro,
      sections: kDerDieDasTheorySections,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.s.artikelExerciseHint,
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
          context.s.statsLine(_richtig, _falsch),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFD6EBFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF007AFF), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.s.welcherArtikel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C3C43),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      q.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: context.s.wordListenTooltip(true),
                    onPressed: _speakPrompt,
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
              if (_showResult) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        correct ? context.s.correctLabel : context.s.incorrectLabel,
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
                      onPressed: _speakFullAnswer,
                      icon: const Icon(Icons.record_voice_over_outlined, size: 20),
                      label: Text(context.s.mitArtikel),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  q.fullAnswer,
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
          context.s.antwort,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _articleTile(
              context: context,
              index: i,
              label: _optLabels[i],
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

  Widget _articleTile({
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
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${String.fromCharCode(65 + index)})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
