import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/mixed_quiz_models.dart';
import '../l10n/app_strings.dart';

/// Модули, соответствующие блокам на главном экране (и миксу).
enum GrammarStatsModule {
  mix,
  derDieDas,
  akkusativArtikel,
  dativArtikel,
  personalpronomenAkkusativ,
  personalpronomenDativ,
  possessivartikelAkkusativ,
  possessivartikelNominativ,
  possessivartikelNomAkk,
  trennbareVerben,
}

class GrammarModuleStats {
  GrammarModuleStats({this.right = 0, this.wrong = 0, Map<String, int>? wrongByTag})
      : wrongByTag = wrongByTag ?? {};

  int right;
  int wrong;
  /// Ошибки по «правильному» тегу (der/die/das, den/die/das, mich/mir …).
  final Map<String, int> wrongByTag;

  int get total => right + wrong;

  double get accuracy => total == 0 ? 0 : right / total;

  void record({required bool ok, String? correctTag}) {
    if (ok) {
      right++;
    } else {
      wrong++;
      if (correctTag != null && correctTag.isNotEmpty) {
        wrongByTag[correctTag] = (wrongByTag[correctTag] ?? 0) + 1;
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'r': right,
        'w': wrong,
        't': wrongByTag.map((k, v) => MapEntry(k, v.clamp(0, 1 << 20))),
      };

  static GrammarModuleStats fromJson(Map<String, dynamic>? j) {
    if (j == null) return GrammarModuleStats();
    final t = <String, int>{};
    final raw = j['t'];
    if (raw is Map) {
      for (final e in raw.entries) {
        final v = e.value;
        if (v is num) t[e.key.toString()] = v.toInt();
      }
    }
    return GrammarModuleStats(
      right: (j['r'] is num) ? (j['r'] as num).toInt().clamp(0, 1 << 20) : 0,
      wrong: (j['w'] is num) ? (j['w'] as num).toInt().clamp(0, 1 << 20) : 0,
      wrongByTag: t,
    );
  }
}

class GrammarStatsState {
  GrammarStatsState({Map<GrammarStatsModule, GrammarModuleStats>? modules})
      : modules = modules ??
            {for (final m in GrammarStatsModule.values) m: GrammarModuleStats()};

  final Map<GrammarStatsModule, GrammarModuleStats> modules;

  GrammarModuleStats statsFor(GrammarStatsModule m) =>
      modules.putIfAbsent(m, GrammarModuleStats.new);

  static GrammarStatsState fromPrefsJson(String? raw) {
    if (raw == null || raw.isEmpty) return GrammarStatsState();
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final out = <GrammarStatsModule, GrammarModuleStats>{};
      for (final m in GrammarStatsModule.values) {
        final block = j[m.name];
        out[m] = GrammarModuleStats.fromJson(
          block is Map<String, dynamic> ? block : null,
        );
      }
      return GrammarStatsState(modules: out);
    } catch (_) {
      return GrammarStatsState();
    }
  }

  String toPrefsJson() => jsonEncode({
        for (final e in modules.entries) e.key.name: e.value.toJson(),
      });

  GrammarStatsState copy() {
    final m = <GrammarStatsModule, GrammarModuleStats>{};
    for (final mod in GrammarStatsModule.values) {
      final s = modules[mod] ?? GrammarModuleStats();
      m[mod] = GrammarModuleStats(
        right: s.right,
        wrong: s.wrong,
        wrongByTag: Map<String, int>.from(s.wrongByTag),
      );
    }
    return GrammarStatsState(modules: m);
  }
}

/// Накопленная статистика ответов по всем грамматическим блокам.
class GrammarStatsService {
  GrammarStatsService._();
  static final GrammarStatsService instance = GrammarStatsService._();

  static const _prefsKey = 'grammar_stats_v1';

  Future<GrammarStatsState> load() async {
    final p = await SharedPreferences.getInstance();
    return GrammarStatsState.fromPrefsJson(p.getString(_prefsKey));
  }

  Future<void> _save(GrammarStatsState s) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_prefsKey, s.toPrefsJson());
  }

  Future<void> record({
    required GrammarStatsModule module,
    required bool ok,
    String? correctTag,
  }) async {
    final state = await load();
    final next = state.copy();
    next.statsFor(module).record(ok: ok, correctTag: correctTag);
    await _save(next);
  }

  static GrammarStatsModule? fromMixedQuiz(MixedQuizModule m) {
    return switch (m) {
      MixedQuizModule.derDieDas => GrammarStatsModule.derDieDas,
      MixedQuizModule.akkusativArtikel => GrammarStatsModule.akkusativArtikel,
      MixedQuizModule.dativArtikel => GrammarStatsModule.dativArtikel,
      MixedQuizModule.personalpronomenAkkusativ =>
        GrammarStatsModule.personalpronomenAkkusativ,
      MixedQuizModule.personalpronomenDativ =>
        GrammarStatsModule.personalpronomenDativ,
      MixedQuizModule.possessivartikelAkkusativ =>
        GrammarStatsModule.possessivartikelAkkusativ,
      MixedQuizModule.possessivartikelNominativ =>
        GrammarStatsModule.possessivartikelNominativ,
      MixedQuizModule.possessivartikelNomAkk =>
        GrammarStatsModule.possessivartikelNomAkk,
      MixedQuizModule.trennbareVerben => GrammarStatsModule.trennbareVerben,
      MixedQuizModule.bestimmterArtikel => null,
    };
  }

  /// Рекомендация для главного экрана; пустая строка — не показывать блок.
  String homeRecommendation(AppStrings s, GrammarStatsState state) {
    final tips = <String>[];

    void addTagTip(GrammarStatsModule mod, String Function(String tag) label) {
      final st = state.modules[mod];
      if (st == null || st.wrong == 0) return;
      final tags = st.wrongByTag.entries.where((e) => e.value > 0).toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (tags.isEmpty) return;
      final top = tags.take(2);
      for (final e in top) {
        tips.add(label(e.key));
      }
    }

    addTagTip(GrammarStatsModule.derDieDas, s.recommendDerDieDasTag);
    addTagTip(GrammarStatsModule.akkusativArtikel, s.recommendAkkusativTag);
    addTagTip(GrammarStatsModule.dativArtikel, s.recommendDativTag);

    final moduleWrong = <GrammarStatsModule, int>{};
    for (final m in GrammarStatsModule.values) {
      if (m == GrammarStatsModule.mix) continue;
      final st = state.modules[m];
      if (st != null && st.wrong > 0) moduleWrong[m] = st.wrong;
    }
    if (moduleWrong.isNotEmpty) {
      final sorted = moduleWrong.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.first;
      if (!tips.any((t) => t.contains(s.moduleTitleForStats(top.key)))) {
        tips.add(s.recommendModuleWeak(top.key));
      }
    }

    if (tips.isEmpty) return '';
    return s.homeRecommendationHeader(tips.take(3).toList());
  }
}
