import 'package:flutter/material.dart';

/// Модуль «Письмо»: формуляр + короткое E-Mail (~30 слов).
class SchreibenScreen extends StatefulWidget {
  const SchreibenScreen({super.key});

  @override
  State<SchreibenScreen> createState() => _SchreibenScreenState();
}

class _SchreibenScreenState extends State<SchreibenScreen> {
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _letterCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _emailCtrl.dispose();
    _letterCtrl.dispose();
    super.dispose();
  }

  int get _wordCount {
    final t = _letterCtrl.text.trim();
    if (t.isEmpty) return 0;
    return t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  static const _situationen = <String>[
    'Sie schreiben an eine Freundin / einen Freund und laden zu einer Party ein.',
    'Sie antworten auf eine Einladung (Ja/Nein + kurze Begründung).',
    'Sie entschuldigen sich, dass Sie einen Termin nicht einhalten können.',
    'Sie bitten um eine Information (Öffnungszeiten, Preis).',
    'Sie bedanken sich für Hilfe oder ein Geschenk.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schreiben — Письмо')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Füllen Sie das Formular aus und schreiben Sie eine kurze E-Mail (ca. 30 Wörter). '
            'Achten Sie auf Anrede, kurzen Mittelteil und Grußformel.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'В этой части нужно заполнить анкету и написать короткое письмо (E-Mail) примерно на 30 слов.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text('Formular', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Name, Vorname',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'Wohnort',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'E-Mail-Adresse',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          Text('Typische Situationen für die E-Mail', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._situationen.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Ihre E-Mail (Entwurf)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _letterCtrl,
            onChanged: (_) => setState(() {}),
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Liebe …,\n\n…\n\nViele Grüße\n…',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wörter: $_wordCount (Ziel: ca. 30)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _wordCount > 0 && (_wordCount - 30).abs() <= 5
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
