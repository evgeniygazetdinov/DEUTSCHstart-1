import 'package:flutter/material.dart';

import '../../data/bestimmter_artikel_questions.dart';
import '../../data/bestimmter_artikel_theory.dart';
import '../../l10n/app_locale_scope.dart';
import '../../widgets/language_switch_button.dart';
import '../../widgets/theory_tab_content.dart';

/// Теория + 50 заданий по bestimmtem Artikel (A1).
class BestimmterArtikelScreen extends StatefulWidget {
  const BestimmterArtikelScreen({super.key});

  @override
  State<BestimmterArtikelScreen> createState() => _BestimmterArtikelScreenState();
}

class _BestimmterArtikelScreenState extends State<BestimmterArtikelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late List<BestimmterArtikelFrage> _fragen;
  int _qIndex = 0;
  int? _picked;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _fragen = allBestimmterArtikelFragen();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  bool get _atEnd => _qIndex >= _fragen.length;
  BestimmterArtikelFrage? get _current => _atEnd ? null : _fragen[_qIndex];

  String _previewLine(BestimmterArtikelFrage q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
  }

  void _select(int i) {
    if (_showResult || _current == null) return;
    setState(() {
      _picked = i;
      _showResult = true;
    });
  }

  void _nextQ() {
    setState(() {
      _qIndex++;
      _picked = null;
      _showResult = false;
    });
  }

  void _restartFragen() {
    setState(() {
      _qIndex = 0;
      _picked = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bestimmter Artikel — A1'),
        actions: const [LanguageSwitchButton()],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: s.theoryTab),
            Tab(text: s.fragen50Tab),
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
      headline: 'Bestimmter Artikel (der, die, das, den)',
      intro: context.s.bestimmterTheoryIntro,
      sections: kBestimmterArtikelTheorySections,
    );
  }

  Widget _buildFragenTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_atEnd) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                context.s.allAufgabenDone(50),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                context.s.bestimmterDoneHint,
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
        LinearProgressIndicator(value: (q.nr) / _fragen.length),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text(
                context.s.bestimmterQueueHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text('${teilLabelDe(q.teil)} · Nr. ${q.nr}/50'),
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
                    child: Text(
                      q.nr >= _fragen.length
                          ? context.s.fertig
                          : context.s.weiter(),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
