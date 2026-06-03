import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_locale_scope.dart';
import '../theme/apple_theme.dart';
import '../widgets/apple_navigation.dart';
import '../widgets/ios_grouped_section.dart';
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

  static const _iconColors = [
    Color(0xFF5856D6),
    Color(0xFF34C759),
    Color(0xFFFF9500),
    Color(0xFFAF52DE),
    Color(0xFF007AFF),
    Color(0xFF32ADE6),
    Color(0xFFFF2D55),
    Color(0xFF30B0C7),
    Color(0xFFA2845E),
    Color(0xFF5AC8FA),
    Color(0xFFFF6482),
    Color(0xFF64D2FF),
    Color(0xFFAC8E68),
  ];

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

    Widget pageFor(int index) => switch (index) {
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

    IosListRow row(_ModuleEntry m, int index) => IosListRow(
          icon: m.icon,
          iconBackground: _iconColors[index % _iconColors.length],
          title: s.moduleTitle(m.titleDe, m.titleLocalized),
          subtitle: m.subtitle,
          onTap: () => Navigator.push(context, applePageRoute(pageFor(index))),
        );

    return Scaffold(
      backgroundColor: AppleTheme.groupedBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: AppleTheme.groupedBackground,
              surfaceTintColor: Colors.transparent,
              actions: [
                LanguageSwitchButton(),
                SizedBox(width: 8),
              ],
              expandedHeight: 0,
              toolbarHeight: 52,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppleTheme.secondaryGrouped,
                    borderRadius:
                        BorderRadius.circular(AppleTheme.cornerRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Text(
                      s.appTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppleTheme.primaryLabel,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppleTheme.groupedMargin,
                ),
                child: IosGroupedSection(
                  header: context.localeController.language ==
                          AppLanguage.ru
                      ? 'Навыки'
                      : 'Skills',
                  children: [
                    row(modules[0], 0),
                    row(modules[1], 1),
                    row(modules[2], 2),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppleTheme.groupedMargin,
                ),
                child: IosGroupedSection(
                  header: 'Grammatik',
                  children: [
                    for (var i = 3; i < modules.length; i++) row(modules[i], i),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
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
