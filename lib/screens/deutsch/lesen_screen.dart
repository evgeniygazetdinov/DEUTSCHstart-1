import 'package:flutter/material.dart';

/// Модуль «Чтение»: объявления, письма, таблички → richtig/falsch или сопоставление.
class LesenScreen extends StatefulWidget {
  const LesenScreen({super.key});

  @override
  State<LesenScreen> createState() => _LesenScreenState();
}

class _LesenScreenState extends State<LesenScreen> {
  bool? _answered;

  static const _text = '''
Bahnhofstraße 12
10115 Berlin

Liebe Kundinnen und Kunden,

unsere Filiale bleibt am Samstag, den 15. Juni, wegen Inventur geschlossen.
Am Sonntag sind wir wie gewohnt von 10 bis 18 Uhr für Sie da.

Ihr Team vom Buchladen „Leselust“
''';

  static const _statement = 'Am Samstag, den 15. Juni, ist der Buchladen geöffnet.';

  void _check(bool userChoseRichtig) {
    // Text: Samstag geschlossen — Aussage „Samstag geöffnet“ ist falsch → richtig ist „falsch“.
    final isCorrect = !userChoseRichtig;
    setState(() => _answered = isCorrect);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? 'Richtig — gut gelesen!' : 'Noch einmal: der Text sagt „geschlossen“ am Samstag.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesen — Чтение')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Lesen Sie die Texte (Aushänge, Briefe, Schilder). '
            'Entscheiden Sie: richtig oder falsch — oder ordnen Sie Text und Situation zu.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь вы читаете объявления, письма и таблички и отвечаете «richtig» или «falsch», '
            'либо сопоставляете текст и ситуацию.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _text.trim(),
                style: const TextStyle(height: 1.5, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.55),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aussage', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  const Text(
                    _statement,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text('Ist die Aussage richtig oder falsch?', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () => _check(true),
                        child: const Text('richtig'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: () => _check(false),
                        child: const Text('falsch'),
                      ),
                    ],
                  ),
                  if (_answered != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _answered! ? 'Sehr gut!' : 'Tipp: nochmal den ersten Satz lesen.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
