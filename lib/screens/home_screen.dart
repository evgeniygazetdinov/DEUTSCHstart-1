import 'package:flutter/material.dart';

import '../l10n/app_locale_scope.dart';
import '../widgets/language_switch_button.dart';
import 'deutsch/hoeren_screen.dart';
import 'deutsch/lesen_screen.dart';
import 'deutsch/sprechen_screen.dart';
import 'deutsch/akkusativ_artikel_screen.dart';
import 'deutsch/artikel_screen.dart';
import 'deutsch/dativ_artikel_screen.dart';
import 'deutsch/personalpronomen_akkusativ_screen.dart';
import 'deutsch/personalpronomen_dativ_screen.dart';
import 'deutsch/possessivartikel_akkusativ_screen.dart';
import 'deutsch/possessivartikel_nominativ_screen.dart';
import 'deutsch/possessivartikel_nom_akk_screen.dart';
import 'deutsch/trennbare_verben_screen.dart';
import 'deutsch/mixed_quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final modules = <_ModuleEntry>[
      _ModuleEntry(
        titleDe: 'Hören',
        titleLocalized: s.moduleHoerenRu,
        icon: Icons.headphones_outlined,
        subtitle: s.subHoeren,
      ),
      _ModuleEntry(
        titleDe: 'Lesen',
        titleLocalized: s.moduleLesenRu,
        icon: Icons.menu_book_outlined,
        subtitle: s.subLesen,
      ),
      _ModuleEntry(
        titleDe: 'Sprechen',
        titleLocalized: s.moduleSprechenRu,
        icon: Icons.record_voice_over_outlined,
        subtitle: s.subSprechen,
      ),
      _ModuleEntry(
        titleDe: 'Mix — Grammatik',
        titleLocalized: s.moduleMixRu,
        icon: Icons.shuffle,
        subtitle: s.subMix,
      ),
      _ModuleEntry(
        titleDe: 'Artikel',
        titleLocalized: s.moduleArtikelRu,
        icon: Icons.article_outlined,
        subtitle: s.subArtikel,
      ),
      _ModuleEntry(
        titleDe: 'Artikel im Akkusativ',
        titleLocalized: s.moduleAkkArtikelRu,
        icon: Icons.view_week_outlined,
        subtitle: s.subAkkArtikel,
      ),
      _ModuleEntry(
        titleDe: 'Artikel im Dativ',
        titleLocalized: s.moduleDatArtikelRu,
        icon: Icons.alt_route_outlined,
        subtitle: s.subDatArtikel,
      ),
      _ModuleEntry(
        titleDe: 'Personalpronomen — Akkusativ',
        titleLocalized: s.modulePersAkkRu,
        icon: Icons.person_outline,
        subtitle: s.subPersAkk,
      ),
      _ModuleEntry(
        titleDe: 'Personalpronomen — Dativ',
        titleLocalized: s.modulePersDatRu,
        icon: Icons.people_outline,
        subtitle: s.subPersDat,
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Akkusativ',
        titleLocalized: s.modulePossAkkRu,
        icon: Icons.home_work_outlined,
        subtitle: s.subPossAkk,
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Nominativ',
        titleLocalized: s.modulePossNomRu,
        icon: Icons.label_important_outline,
        subtitle: s.subPossNom,
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Nom. vs. Akk.',
        titleLocalized: s.modulePossNomAkkRu,
        icon: Icons.compare_arrows,
        subtitle: s.subPossNomAkk,
      ),
      _ModuleEntry(
        titleDe: 'Trennbare Verben',
        titleLocalized: s.moduleTrennbarRu,
        icon: Icons.call_split,
        subtitle: s.subTrennbar,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.appTitle),
        actions: const [LanguageSwitchButton()],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final m = modules[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                radius: 26,
                child: Icon(m.icon, size: 28),
              ),
              title: Text(
                s.moduleTitle(m.titleDe, m.titleLocalized),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(m.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final page = switch (index) {
                  0 => const HoerenScreen(),
                  1 => const LesenScreen(),
                  2 => const SprechenScreen(),
                  3 => const MixedQuizScreen(),
                  4 => const ArtikelScreen(),
                  5 => const AkkusativArtikelScreen(),
                  6 => const DativArtikelScreen(),
                  7 => const PersonalpronomenAkkusativScreen(),
                  8 => const PersonalpronomenDativScreen(),
                  9 => const PossessivartikelAkkusativScreen(),
                  10 => const PossessivartikelNominativScreen(),
                  11 => const PossessivartikelNomAkkScreen(),
                  12 => const TrennbareVerbenScreen(),
                  _ => const HoerenScreen(),
                };
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ModuleEntry {
  const _ModuleEntry({
    required this.titleDe,
    required this.titleLocalized,
    required this.icon,
    required this.subtitle,
  });

  final String titleDe;
  final String titleLocalized;
  final IconData icon;
  final String subtitle;
}
