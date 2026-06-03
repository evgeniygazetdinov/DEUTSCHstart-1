import 'package:flutter/material.dart';

import '../../l10n/app_locale_scope.dart';
import '../../widgets/language_switch_button.dart';

/// Модуль «Говорение»: знакомство, тематические карточки, вежливые формулы.
class SprechenScreen extends StatelessWidget {
  const SprechenScreen({super.key});

  static const _teil1 = <String>[
    'Sich vorstellen: Name, Herkunft, Wohnort, Sprachen.',
    'Buchstabieren: Namen, E-Mail-Adresse, Straße (Buchstaben deutlich).',
    'Zahlen: Telefonnummer, Uhrzeit, Preis, Datum.',
  ];

  static const _teil2 = <String>[
    'Themenkarten: kurz antworten (ca. 1 Minute) zu Alltagsthemen '
        '(Freizeit, Arbeit, Familie, Essen, Wetter …).',
    'Struktur: Einleitung → 2–3 Sätze Inhalt → kurzer Abschluss.',
  ];

  static const _teil3 = <String>[
    'Höfliche Bitten: „Könnten Sie mir bitte …?“, „Darf ich …?“, „Würden Sie …?“',
    'Formeln: Entschuldigung, Dank, Einverständnis, Wiederholung bitten.',
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.sprechenAppBar),
          actions: const [LanguageSwitchButton()],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '1. Kennenlernen'),
              Tab(text: '2. Themenkarten'),
              Tab(text: '3. Höfliche Bitten'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TeilPanel(
              title: s.sprechenTeil1Title,
              subtitle:
                  'Buchstabieren, Zahlen: Sie stellen sich vor und beantworten einfache Fragen zur Person.',
              hint: s.sprechenTeil1Hint,
              points: _teil1,
            ),
            _TeilPanel(
              title: s.sprechenTeil2Title,
              subtitle:
                  'Sie ziehen eine Karte mit einem Thema und sprechen frei dazu.',
              hint: s.sprechenTeil2Hint,
              points: _teil2,
            ),
            _TeilPanel(
              title: s.sprechenTeil3Title,
              subtitle:
                  'Feststehende Redewendungen für Alltagssituationen (Bahnhof, Restaurant, Behörde …).',
              hint: s.sprechenTeil3Hint,
              points: _teil3,
            ),
          ],
        ),
      ),
    );
  }
}

class _TeilPanel extends StatelessWidget {
  const _TeilPanel({
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.points,
  });

  final String title;
  final String subtitle;
  final String hint;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text(
          hint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        ...points.map(
          (p) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                p,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
