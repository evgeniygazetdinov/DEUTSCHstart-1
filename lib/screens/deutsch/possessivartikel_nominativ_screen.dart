import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/possessivartikel_nominativ_questions.dart';
import '../../data/possessivartikel_nominativ_theory.dart';
import '../../l10n/app_locale_scope.dart';
import '../../services/grammar_stats_service.dart';
import '../../utils/artikel_stats_feedback.dart';
import '../../utils/record_grammar_answer.dart';
import '../../widgets/language_switch_button.dart';
import '../../widgets/theory_tab_content.dart';

/// Теория + упражнения Possessivartikel im Nominativ (A1 / Start Deutsch 1).
class PossessivartikelNominativScreen extends StatefulWidget {
  const PossessivartikelNominativScreen({super.key});

  @override
  State<PossessivartikelNominativScreen> createState() =>
      _PossessivartikelNominativScreenState();
}

class _PossessivartikelNominativScreenState
    extends State<PossessivartikelNominativScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late List<PossessivartikelNomFrage> _queue;
  late int _zielAnzahl;
  final Random _random = Random();
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _queue = List<PossessivartikelNomFrage>.from(allPossessivartikelNomFragen());
    _zielAnzahl = _queue.length;
    _queue.shuffle(_random);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  bool get _atEnd => _queue.isEmpty;
  PossessivartikelNomFrage? get _current => _atEnd ? null : _queue.first;

  String _previewLine(PossessivartikelNomFrage q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
  }

  void _select(int i) {
    if (_showResult || _current == null) return;
    final q = _current!;
    final ok = i == q.correctIndex;
    recordGrammarAnswer(
      module: GrammarStatsModule.possessivartikelNominativ,
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

  void _nextQ() {
    if (_current == null) return;
    final q = _queue.first;
    final wasCorrect = _picked == q.correctIndex;
    setState(() {
      _queue.removeAt(0);
      if (!wasCorrect) {
        if (_queue.isEmpty) {
          _queue.add(q);
        } else {
          final pos = 1 + _random.nextInt(_queue.length);
          _queue.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
    });
  }

  void _restartFragen() {
    setState(() {
      _queue = List<PossessivartikelNomFrage>.from(allPossessivartikelNomFragen());
      _zielAnzahl = _queue.length;
      _queue.shuffle(_random);
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
  }

  String _weiterButtonLabel(BuildContext context) {
    final s = context.s;
    final q = _queue.first;
    if (_queue.length == 1 && _showResult && _picked == q.correctIndex) {
      return s.fertig;
    }
    return s.weiter();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Possessivartikel — Nominativ — A1'),
        actions: const [LanguageSwitchButton()],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: s.theoryTab),
            Tab(text: s.fragenTab(_zielAnzahl)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildTheoryTab(context),
          _buildFragenTab(context),
        ],
      ),
    );
  }

  Widget _buildTheoryTab(BuildContext context) {
    return TheoryTabContent(
      headline: 'Possessivartikel im Nominativ',
      intro: context.s.possNomTheoryIntro,
      sections: kPossessivartikelNomTheorySections,
    );
  }

  Widget _buildFragenTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_atEnd) {
      final p = artikelAntwortProzent(_richtig, _falsch) ?? 0;
      final fb = context.s.artikelFeedback(
        p,
        ArtikelStatsModul.possessivartikelNominativ,
      );
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                context.s.allAufgabenDone(_zielAnzahl),
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
                context.s.theoryHintDone,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _restartFragen,
                child: Text(context.s.nochEinmal),
              ),
            ],
          ),
        ),
      );
    }

    final q = _current!;
    final correct = _picked == q.correctIndex;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_richtig / _zielAnzahl).clamp(0.0, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.s.statsLine(_richtig, _falsch),
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
              Text(
                context.s.theoryHintQueue,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  context.s.chipProgress(
                    possessivartikelNomTeilLabelDe(q.teil),
                    q.nr,
                    _zielAnzahl,
                    _queue.length,
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
                context.s.choosePrompt,
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
                  correct ? context.s.correctLabel : context.s.incorrectLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: correct ? Colors.green.shade700 : scheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.s.solutionLabel,
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
                    child: Text(_weiterButtonLabel(context)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
