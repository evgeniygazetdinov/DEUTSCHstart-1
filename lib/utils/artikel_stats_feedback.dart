/// Модуль для текстов итоговой оценки (процент верных ответов за проход).
enum ArtikelStatsModul {
  nominativDerDieDas,
  akkusativ,
  dativ,
  personalpronomenAkkusativ,
  personalpronomenDativ,
  possessivartikelAkkusativ,
  possessivartikelNominativ,
  possessivartikelNomAkk,
  trennbareVerben,
}

/// Доля верных ответов в процентах (0–100), либо `null`, если ответов ещё не было.
int? artikelAntwortProzent(int richtig, int falsch) {
  final g = richtig + falsch;
  if (g == 0) return null;
  return ((richtig * 100.0) / g).round();
}

// Строки статистики и обратной связи — в [AppStrings.artikelFeedback] / statsLine.
