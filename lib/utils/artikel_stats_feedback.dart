/// Модуль для текстов итоговой оценки (процент верных ответов за проход).
enum ArtikelStatsModul {
  nominativDerDieDas,
  akkusativ,
  dativ,
}

/// Доля верных ответов в процентах (0–100), либо `null`, если ответов ещё не было.
int? artikelAntwortProzent(int richtig, int falsch) {
  final g = richtig + falsch;
  if (g == 0) return null;
  return ((richtig * 100.0) / g).round();
}

/// Строка текущей сессии: верно / неверно / процент.
String artikelStatistikZeileRu(int richtig, int falsch) {
  final p = artikelAntwortProzent(richtig, falsch);
  final pStr = p == null ? '—' : '$p%';
  return 'Верно: $richtig · Неверно: $falsch · $pStr';
}

/// Звёзды и формулировка по шкале 90 / 80 / 70 / 60 / ниже.
({String sterne, String meldung}) artikelFeedbackNachProzent(
  int prozent,
  ArtikelStatsModul modul,
) {
  if (prozent >= 90) {
    return (
      sterne: '⭐⭐⭐',
      meldung: switch (modul) {
        ArtikelStatsModul.akkusativ => 'Эксперт A1! Вы идеально знаете Akkusativ.',
        ArtikelStatsModul.dativ => 'Эксперт A1! Вы отлично знаете Artikel im Dativ.',
        ArtikelStatsModul.nominativDerDieDas =>
          'Эксперт A1! Вы отлично знаете der / die / das в Nominativ.',
      },
    );
  }
  if (prozent >= 80) {
    return (
      sterne: '⭐⭐',
      meldung: 'Очень хорошо. Несколько мелких ошибок.',
    );
  }
  if (prozent >= 70) {
    return (
      sterne: '⭐',
      meldung: 'Хорошо. Повторите мужской род.',
    );
  }
  if (prozent >= 60) {
    return (
      sterne: '⚠️',
      meldung: 'Средне. Учите таблицу артиклей.',
    );
  }
  return (
    sterne: '🔄',
    meldung: 'Нужно повторить теорию.',
  );
}
