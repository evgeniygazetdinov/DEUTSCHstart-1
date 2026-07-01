import 'package:flutter/material.dart';

import '../l10n/app_locale_scope.dart';
import '../services/grammar_stats_service.dart';
import '../theme/apple_theme.dart';
import '../widgets/apple_navigation.dart';
import '../widgets/ios_grouped_section.dart';
import '../widgets/language_switch_button.dart';
import '../widgets/module_stats_bar.dart';
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
import 'deutsch/zahlen_uhrzeit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GrammarStatsState? _stats;

  static const _iconColors = [
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

  static const _statsModules = [
    GrammarStatsModule.mix,
    GrammarStatsModule.derDieDas,
    GrammarStatsModule.zahlenUhrzeit,
    GrammarStatsModule.akkusativArtikel,
    GrammarStatsModule.dativArtikel,
    GrammarStatsModule.personalpronomenAkkusativ,
    GrammarStatsModule.personalpronomenDativ,
    GrammarStatsModule.possessivartikelAkkusativ,
    GrammarStatsModule.possessivartikelNominativ,
    GrammarStatsModule.possessivartikelNomAkk,
    GrammarStatsModule.trennbareVerben,
  ];

  @override
  void initState() {
    super.initState();
    _reloadStats();
  }

  Future<void> _reloadStats() async {
    final st = await GrammarStatsService.instance.load();
    if (!mounted) return;
    setState(() => _stats = st);
  }

  Future<void> _openModule(Widget page) async {
    await Navigator.push(context, applePageRoute(page));
    await _reloadStats();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final stats = _stats;
    final reco = stats == null
        ? ''
        : GrammarStatsService.instance.homeRecommendation(s, stats);

    final modules = <_ModuleEntry>[
      _ModuleEntry(
        titleDe: 'Mix — Grammatik',
        titleLocalized: s.moduleMixRu,
        icon: Icons.shuffle,
        subtitle: s.subMix,
        page: const MixedQuizScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Artikel',
        titleLocalized: s.moduleArtikelRu,
        icon: Icons.article_outlined,
        subtitle: s.subArtikel,
        page: const ArtikelScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Zahlen & Uhrzeit',
        titleLocalized: s.moduleZahlenRu,
        icon: Icons.schedule_outlined,
        subtitle: s.subZahlen,
        page: const ZahlenUhrzeitScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Artikel im Akkusativ',
        titleLocalized: s.moduleAkkArtikelRu,
        icon: Icons.view_week_outlined,
        subtitle: s.subAkkArtikel,
        page: const AkkusativArtikelScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Artikel im Dativ',
        titleLocalized: s.moduleDatArtikelRu,
        icon: Icons.alt_route_outlined,
        subtitle: s.subDatArtikel,
        page: const DativArtikelScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Personalpronomen — Akkusativ',
        titleLocalized: s.modulePersAkkRu,
        icon: Icons.person_outline,
        subtitle: s.subPersAkk,
        page: const PersonalpronomenAkkusativScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Personalpronomen — Dativ',
        titleLocalized: s.modulePersDatRu,
        icon: Icons.people_outline,
        subtitle: s.subPersDat,
        page: const PersonalpronomenDativScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Akkusativ',
        titleLocalized: s.modulePossAkkRu,
        icon: Icons.home_work_outlined,
        subtitle: s.subPossAkk,
        page: const PossessivartikelAkkusativScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Nominativ',
        titleLocalized: s.modulePossNomRu,
        icon: Icons.label_important_outline,
        subtitle: s.subPossNom,
        page: const PossessivartikelNominativScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Possessivartikel — Nom. vs. Akk.',
        titleLocalized: s.modulePossNomAkkRu,
        icon: Icons.compare_arrows,
        subtitle: s.subPossNomAkk,
        page: const PossessivartikelNomAkkScreen(),
      ),
      _ModuleEntry(
        titleDe: 'Trennbare Verben',
        titleLocalized: s.moduleTrennbarRu,
        icon: Icons.call_split,
        subtitle: s.subTrennbar,
        page: const TrennbareVerbenScreen(),
      ),
    ];

    Widget moduleBlock(_ModuleEntry m, int index) {
      final modStats =
          stats?.modules[_statsModules[index]] ?? GrammarModuleStats();
      final pct =
          modStats.total == 0 ? 0 : (modStats.accuracy * 100).round();
      final showBar = index == 0 && modStats.total > 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showBar)
              ModuleStatsBar(
                stats: modStats,
                answersLabel: s.moduleAnswersLine(modStats.total, pct),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppleTheme.cornerRadius),
              child: IosListRow(
                icon: m.icon,
                iconBackground: _iconColors[index % _iconColors.length],
                title: s.moduleTitle(m.titleDe, m.titleLocalized),
                subtitle: m.subtitle,
                onTap: () => _openModule(m.page),
              ),
            ),
          ],
        ),
      );
    }

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
            if (reco.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppleTheme.secondaryGrouped,
                      borderRadius:
                          BorderRadius.circular(AppleTheme.cornerRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.homeRecoTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reco,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.4,
                                  color: AppleTheme.secondaryLabel,
                                ),
                          ),
                        ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      child: Text(
                        'GRAMMATIK',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.08,
                              color: AppleTheme.secondaryLabel,
                            ),
                      ),
                    ),
                    for (var i = 0; i < modules.length; i++)
                      moduleBlock(modules[i], i),
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
    required this.page,
  });

  final String titleDe;
  final String titleLocalized;
  final IconData icon;
  final String subtitle;
  final Widget page;
}
