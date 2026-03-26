import 'package:flutter/material.dart';

/// Модуль «Аудирование»: диалоги/объявления → выбор картинки или richtig/falsch.
class HoerenScreen extends StatefulWidget {
  const HoerenScreen({super.key});

  @override
  State<HoerenScreen> createState() => _HoerenScreenState();
}

class _HoerenScreenState extends State<HoerenScreen> {
  int? _selectedImage;
  bool? _lastChoice;

  static const _instructionDe =
      'Hören Sie den Text oder das Gespräch. Entscheiden Sie: Welches Bild passt? '
      'Oder: Ist die Aussage richtig oder falsch?';

  void _onAnswer(bool richtig) {
    setState(() => _lastChoice = richtig);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(richtig ? 'Richtig ✓' : 'Falsch — üben Sie weiter.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hören — Аудирование')),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
            'В этой части вы слушаете диалоги или объявления и отмечаете правильную картинку '
            '(richtig/falsch или выбор из вариантов). Ниже — демо без аудио: выберите картинку, '
            'которая соответствует фразе.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beispiel-Satz (wie nach dem Hören):',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '„Der Zug nach München fährt von Gleis 7 ab.“',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text('Welches Bild passt?', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _PictureChoice(
                          label: 'Zug',
                          icon: Icons.train,
                          selected: _selectedImage == 0,
                          onTap: () => setState(() => _selectedImage = 0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PictureChoice(
                          label: 'Bus',
                          icon: Icons.directions_bus,
                          selected: _selectedImage == 1,
                          onTap: () => setState(() => _selectedImage = 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oder: „Die Aussage zum Bild ist richtig.“',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FilledButton.tonal(
                        onPressed: () => _onAnswer(true),
                        child: const Text('richtig'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: () => _onAnswer(false),
                        child: const Text('falsch'),
                      ),
                    ],
                  ),
                  if (_lastChoice != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Letzte Antwort (Demo): ${_lastChoice! ? "richtig" : "falsch"}',
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

class _PictureChoice extends StatelessWidget {
  const _PictureChoice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Material(
      color: selected ? color.primaryContainer : color.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
