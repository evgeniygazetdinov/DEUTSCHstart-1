import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/hoeren_exercises.dart';
import '../../services/linux_shell_tts.dart';
import '../../widgets/tappable_hortext.dart';

/// Модуль «Аудирование»: диалоги/объявления → выбор A/B/C или richtig/falsch.
class HoerenScreen extends StatefulWidget {
  const HoerenScreen({super.key});

  @override
  State<HoerenScreen> createState() => _HoerenScreenState();
}

class _HoerenScreenState extends State<HoerenScreen> {
  late List<HoerenExercise> _exercises;
  final Random _random = Random();
  int _index = 0;

  int? _pictureSelected;
  List<int?> _rfPicked = [];

  final FlutterTts _tts = FlutterTts();
  final LinuxShellTts _linuxTts = LinuxShellTts();
  bool _linuxMode = false;
  bool _isSpeaking = false;

  static const _instructionDe =
      'Hören Sie den Text oder das Gespräch. Entscheiden Sie: Welches Bild passt? '
      'Oder: Ist die Aussage richtig oder falsch?';

  static final RegExp _leadingAbcParen = RegExp(r'^[A-C]\)\s*');

  HoerenExercise get _current => _exercises[_index];

  bool get _atEnd => _index >= _exercises.length;

  bool get _canGoNext {
    if (_atEnd) return false;
    return switch (_current) {
      HoerenPictureExercise() => _pictureSelected != null,
      HoerenRichtigFalschExercise(:final items) =>
        _rfPicked.length == items.length &&
            _rfPicked.every((p) => p != null),
      HoerenOpenExercise() => true,
    };
  }

  @override
  void initState() {
    super.initState();
    _linuxMode = !kIsWeb && isLinuxHost;
    _exercises = shuffledHoerenExercises(_random);
    _syncLocalStateForCurrent();
    _initTts();
  }

  void _syncLocalStateForCurrent() {
    if (_atEnd) return;
    _pictureSelected = null;
    final e = _current;
    if (e is HoerenRichtigFalschExercise) {
      _rfPicked = List<int?>.filled(e.items.length, null);
    } else {
      _rfPicked = [];
    }
  }

  Future<void> _stopAudio() async {
    if (_linuxMode) {
      await _linuxTts.stop();
    } else {
      await _tts.stop();
    }
    if (mounted) setState(() => _isSpeaking = false);
  }

  void _reshuffle() {
    _stopAudio();
    setState(() {
      _exercises = shuffledHoerenExercises(_random);
      _index = 0;
      _syncLocalStateForCurrent();
    });
  }

  Future<void> _initTts() async {
    if (_linuxMode) {
      return;
    }
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((msg) {
      if (!mounted) return;
      setState(() => _isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Озвучка: $msg'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
    await _tts.setLanguage('de-DE');
    await _tts.setSpeechRate(0.45);
  }

  @override
  void dispose() {
    if (_linuxMode) {
      _linuxTts.stop();
    } else {
      _tts.stop();
    }
    super.dispose();
  }

  Future<void> _toggleHortextAudio() async {
    if (_atEnd) return;
    final text = _current.hortext;
    if (_isSpeaking) {
      if (_linuxMode) {
        await _linuxTts.stop();
      } else {
        await _tts.stop();
      }
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }
    setState(() => _isSpeaking = true);
    if (_linuxMode) {
      final ok = await _linuxTts.speak(
        text,
        onComplete: () {
          if (mounted) setState(() => _isSpeaking = false);
        },
      );
      if (!mounted) return;
      if (!ok) {
        setState(() => _isSpeaking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'На Linux нужен синтез речи: установите пакет espeak-ng '
              '(например: sudo apt install espeak-ng).',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    await _tts.speak(text);
  }

  void _nextExercise() {
    if (!_canGoNext) return;
    _stopAudio();
    setState(() {
      _index++;
      _syncLocalStateForCurrent();
    });
  }

  void _pickPicture(int i) {
    setState(() => _pictureSelected = i);
  }

  void _pickRf(int statementIndex, bool choseRichtig) {
    setState(() {
      _rfPicked[statementIndex] = choseRichtig ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hören — Аудирование'),
        actions: [
          IconButton(
            tooltip: 'Neue Reihenfolge',
            onPressed: _reshuffle,
            icon: const Icon(Icons.shuffle_rounded),
          ),
        ],
      ),
      bottomNavigationBar: _atEnd
          ? null
          : Material(
              elevation: 6,
              shadowColor: Colors.black26,
              color: scheme.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _canGoNext ? _nextExercise : null,
                      child: Text(
                        _index + 1 >= _exercises.length
                            ? 'Fertig'
                            : 'Weiter (${_index + 1}/${_exercises.length})',
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              _instructionDe,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Задания из Teil 1–3 и бонус — в случайном порядке. Слушайте текст (play), затем отвечайте. '
              'Пунктир — нажмите слово для перевода (вопрос, варианты, утверждения). '
              'В вариантах A–B–C выбор: нажмите круг с буквой слева; справа — текст с переводами по словам.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            if (!_atEnd) ...[
              LinearProgressIndicator(
                value: (_index + 1) / _exercises.length,
              ),
              const SizedBox(height: 12),
              _buildExerciseCard(context),
            ] else
              _buildDoneCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Runde zu Ende',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Нажмите «shuffle» на панели сверху, чтобы пройти те же задания в новом порядке.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context) {
    final e = _current;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(e.teil),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TappableHortext(
                    text: e.title,
                    wordHints: e.wordHints,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 420;
                final hortext = TappableHortext(
                  text: e.hortext,
                  wordHints: e.wordHints,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
                final play = IconButton.filledTonal(
                  tooltip: _isSpeaking ? 'Stopp' : 'Anhören',
                  onPressed: _toggleHortextAudio,
                  icon: Icon(
                    _isSpeaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  ),
                );
                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: play,
                      ),
                      hortext,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: hortext),
                    play,
                  ],
                );
              },
            ),
            const Divider(height: 28),
            switch (e) {
              HoerenPictureExercise() => _buildPicturePart(context, e),
              HoerenRichtigFalschExercise() => _buildRfPart(context, e),
              HoerenOpenExercise() => _buildOpenPart(context, e),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildPicturePart(BuildContext context, HoerenPictureExercise e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TappableHortext(
          text: e.question,
          wordHints: e.wordHints,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < e.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _abcOptionTile(
              context: context,
              index: i,
              optionText: e.options[i].replaceFirst(_leadingAbcParen, '').trim(),
              wordHints: e.wordHints,
              selected: _pictureSelected == i,
              showResult: _pictureSelected != null,
              correct: i == e.correctIndex,
              onSelectLetter: _pictureSelected == null ? () => _pickPicture(i) : null,
            ),
          ),
        if (_pictureSelected != null) ...[
          const SizedBox(height: 8),
          Text(
            _pictureSelected == e.correctIndex
                ? 'Richtig ✓'
                : 'Nicht richtig.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _pictureSelected == e.correctIndex
                  ? Colors.green.shade700
                  : Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 4),
          TappableHortext(
            text: e.explanation,
            wordHints: e.wordHints,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _abcOptionTile({
    required BuildContext context,
    required int index,
    required String optionText,
    required Map<String, String> wordHints,
    required bool selected,
    required bool showResult,
    required bool correct,
    required VoidCallback? onSelectLetter,
  }) {
    final scheme = Theme.of(context).colorScheme;
    Color? border;
    Color? bg;
    if (showResult) {
      if (correct) {
        border = Colors.green.shade600;
        bg = Colors.green.shade50;
      } else if (selected && !correct) {
        border = scheme.error;
        bg = scheme.errorContainer.withValues(alpha: 0.35);
      }
    } else if (selected) {
      border = scheme.primary;
      bg = scheme.primaryContainer.withValues(alpha: 0.5);
    }
    return Container(
      decoration: BoxDecoration(
        color: bg ?? scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border ?? scheme.outlineVariant,
          width: border != null ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: selected
                ? scheme.primaryContainer
                : scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onSelectLetter,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: TappableHortext(
                text: optionText,
                wordHints: wordHints,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.35,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRfPart(BuildContext context, HoerenRichtigFalschExercise e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TappableHortext(
          text: 'Richtig oder falsch?',
          wordHints: e.wordHints,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        for (var j = 0; j < e.items.length; j++) ...[
          TappableHortext(
            text: e.items[j].statement,
            wordHints: e.wordHints,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _rfButton(
                context,
                label: 'richtig',
                isRichtigButton: true,
                correctIsRichtig: e.items[j].correctIsRichtig,
                picked: _rfPicked[j],
                onTap: _rfPicked[j] == null ? () => _pickRf(j, true) : null,
              ),
              const SizedBox(width: 10),
              _rfButton(
                context,
                label: 'falsch',
                isRichtigButton: false,
                correctIsRichtig: e.items[j].correctIsRichtig,
                picked: _rfPicked[j],
                onTap: _rfPicked[j] == null ? () => _pickRf(j, false) : null,
              ),
            ],
          ),
          if (_rfPicked[j] != null) ...[
            const SizedBox(height: 6),
            TappableHortext(
              text: e.items[j].explanation,
              wordHints: e.wordHints,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _rfButton(
    BuildContext context, {
    required String label,
    required bool isRichtigButton,
    required bool correctIsRichtig,
    required int? picked,
    required VoidCallback? onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final thisIsCorrectAnswer = isRichtigButton == correctIsRichtig;
    final userPickedThis = picked != null &&
        ((isRichtigButton && picked == 1) || (!isRichtigButton && picked == 0));

    Color bg;
    Color fg;
    if (picked != null) {
      if (thisIsCorrectAnswer) {
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
      } else if (userPickedThis) {
        bg = scheme.errorContainer;
        fg = scheme.onErrorContainer;
      } else {
        bg = scheme.surfaceContainerHigh;
        fg = scheme.onSurfaceVariant;
      }
    } else {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurface;
    }
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildOpenPart(BuildContext context, HoerenOpenExercise e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TappableHortext(
          text: 'Zum Üben (kein Prüfungsformat)',
          wordHints: e.wordHints,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...e.qa.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: TappableHortext(
                text: item.question,
                wordHints: e.wordHints,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      item.answer,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
