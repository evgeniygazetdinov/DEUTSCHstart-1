import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/der_die_das_data.dart';
import '../../services/german_word_tts.dart';

/// Упражнение: выбрать артикль der / die / das для существительного.
class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  static const _optLabels = ['der', 'die', 'das'];

  late List<DerDieDasQuestion> _items;
  final Random _random = Random();
  int _index = 0;
  int? _picked;
  bool _showResult = false;

  bool get _atEnd => _index >= _items.length;

  DerDieDasQuestion? get _current => _atEnd ? null : _items[_index];

  @override
  void initState() {
    super.initState();
    _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
  }

  void _reshuffle() {
    GermanWordTts.instance.stop();
    setState(() {
      _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
      _index = 0;
      _picked = null;
      _showResult = false;
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
    setState(() {
      _picked = i;
      _showResult = true;
    });
  }

  void _next() {
    if (!_showResult) return;
    GermanWordTts.instance.stop();
    setState(() {
      _index++;
      _picked = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel — der / die / das'),
        actions: [
          IconButton(
            tooltip: 'Neue Reihenfolge',
            onPressed: _reshuffle,
            icon: const Icon(Icons.shuffle_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: _atEnd ? _buildDone(context) : _buildQuestion(context, scheme),
        ),
      ),
      bottomNavigationBar: _atEnd || !_showResult
          ? null
          : Material(
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
                      child: Text(
                        _index + 1 >= _items.length
                            ? 'Fertig'
                            : 'Weiter (${_index + 1}/${_items.length})',
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDone(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alle ${_items.length} Fragen durch',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'Нажмите shuffle на панели, чтобы пройти карточки в новом порядке.',
                textAlign: TextAlign.center,
              ),
            ],
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
          'Выберите артикль для слова. Под ним — перевод на русский. '
          'Динамик произносит только немецкое слово, без артикля.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: (_index + 1) / _items.length),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcher Artikel?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.prompt,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            q.translationRu,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                  height: 1.35,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Wort anhören (ohne Artikel)',
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
                          correct ? 'Richtig ✓' : 'Nicht richtig.',
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
                        label: const Text('Mit Artikel'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.fullAnswer,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Antwort',
          style: Theme.of(context).textTheme.titleSmall,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
