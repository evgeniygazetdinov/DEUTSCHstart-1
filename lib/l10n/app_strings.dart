import '../data/mixed_quiz_models.dart';
import '../services/grammar_stats_service.dart';
import '../utils/artikel_stats_feedback.dart';
import 'app_locale.dart';

/// Строки служебного UI (не учебный контент упражнений).
class AppStrings {
  const AppStrings(this._lang);

  final AppLanguage _lang;

  bool get _ru => _lang == AppLanguage.ru;

  // ——— Общие кнопки и подписи ———
  String get appTitle => 'Deutsch A1 Start';

  String get theoryTab => _ru ? 'Теория' : 'Theory';
  String fragenTab(int n) => _ru ? 'Задания ($n)' : 'Questions ($n)';
  String uebungenTab(int n) => _ru ? 'Упражнения ($n)' : 'Exercises ($n)';
  String get fragen50Tab => _ru ? '50 заданий' : '50 questions';

  String get choosePrompt => _ru ? 'Выберите:' : 'Choose:';
  String get correctLabel => _ru ? 'Верно ✓' : 'Correct ✓';
  String get incorrectLabel => _ru ? 'Неверно.' : 'Not correct.';
  String get solutionLabel => _ru ? 'Решение:' : 'Solution:';
  String get nochEinmal => _ru ? 'Ещё раз' : 'Again';
  String get fertig => _ru ? 'Готово' : 'Done';
  String weiter() => _ru ? 'Далее' : 'Next';
  String weiterNoch(int n) => _ru ? 'Далее (осталось $n)' : 'Next ($n left)';
  String weiterProgress(int current, int total) =>
      _ru ? 'Далее ($current/$total)' : 'Next ($current/$total)';
  String weiterAufgabe(int index, int total) =>
      _ru ? 'Далее (задание $index/$total)' : 'Next (task $index/$total)';
  String naechsteFrage(int next, int total) =>
      _ru ? 'Следующий вопрос ($next/$total)' : 'Next question ($next/$total)';

  String allAufgabenDone(int n) =>
      _ru ? 'Все $n заданий пройдены' : 'All $n tasks completed';
  String allFragenDone(int n) =>
      _ru ? 'Все $n вопросов пройдены' : 'All $n questions completed';

  String statsLine(int richtig, int falsch) {
    final p = richtig + falsch == 0
        ? '—'
        : '${((richtig * 100.0) / (richtig + falsch)).round()}%';
    return statsLineWithPercent(richtig, falsch, p);
  }

  String statsLineWithPercent(int richtig, int falsch, Object percent) => _ru
      ? 'Верно: $richtig · Неверно: $falsch · $percent'
      : 'Correct: $richtig · Wrong: $falsch · $percent';

  String statsLineRemaining(int richtig, int falsch, int left) => _ru
      ? 'Верно: $richtig · Неверно: $falsch · осталось $left'
      : 'Correct: $richtig · Wrong: $falsch · $left left';

  String chipProgress(String teilLabel, int nr, int ziel, int queueLeft) =>
      _ru
          ? '$teilLabel · № $nr/$ziel · осталось $queueLeft'
          : '$teilLabel · No. $nr/$ziel · $queueLeft left';

  String get theoryHintDone =>
      _ru
          ? 'Сверьтесь с разделом «Теория» при необходимости.'
          : 'Check the Theory tab if needed.';

  String get theoryHintQueue => _ru
      ? 'При необходимости откройте вкладку «Теория». '
          'При ошибке задание вернётся позже в очередь.'
      : 'Open the Theory tab if needed. '
          'Wrong answers return to the queue later.';

  String get theoryHintQueueRetry => _ru
      ? 'При необходимости откройте вкладку «Теория». '
          'При ошибке задание вернётся позже в очередь — можно ответить верно.'
      : 'Open the Theory tab if needed. '
          'Wrong answers return to the queue — you can answer correctly later.';

  String get shuffleTooltip => _ru ? 'Новый порядок' : 'New order';
  String get shuffleHintArtikel => _ru
      ? 'Нажмите shuffle на панели, чтобы начать новый проход и обнулить статистику.'
      : 'Tap shuffle in the app bar to start a new run and reset stats.';

  String get richtig => 'richtig';
  String get falsch => 'falsch';

  // ——— Язык приложения ———
  String get languageSwitchToEn => _ru ? 'Переключить на English' : 'Switch to English';
  String get languageSwitchToRu => _ru ? 'Переключить на русский' : 'Switch to Russian';

  // ——— Главный экран ———
  String moduleTitle(String titleDe, String titleLocalized) =>
      '$titleDe — $titleLocalized';

  String get moduleHoerenRu => _ru ? 'Аудирование' : 'Listening';
  String get moduleLesenRu => _ru ? 'Чтение' : 'Reading';
  String get moduleSprechenRu => _ru ? 'Говорение' : 'Speaking';
  String get moduleMixRu => _ru ? 'Общий микс' : 'Mixed quiz';
  String get moduleArtikelRu => _ru ? 'Артикли' : 'Articles';
  String get moduleAkkArtikelRu =>
      _ru ? 'Артикль, винительный падеж' : 'Article, accusative';
  String get moduleDatArtikelRu =>
      _ru ? 'Артикль, дательный падеж' : 'Article, dative';
  String get modulePersAkkRu =>
      _ru ? 'Личные местоимения, винительный падеж' : 'Personal pronouns, accusative';
  String get modulePersDatRu =>
      _ru ? 'Личные местоимения, дательный падеж' : 'Personal pronouns, dative';
  String get modulePossAkkRu =>
      _ru ? 'Притяжательные артикли, винительный падеж' : 'Possessive articles, accusative';
  String get modulePossNomRu =>
      _ru ? 'Притяжательные артикли, именительный падеж' : 'Possessive articles, nominative';
  String get modulePossNomAkkRu =>
      _ru ? 'Притяжательные: Nom. и Akk.' : 'Possessive: nom. vs. acc.';
  String get moduleTrennbarRu => _ru ? 'Отделяемые глаголы' : 'Separable verbs';

  String get subHoeren => _ru
      ? 'Диалоги и объявления: правильная картинка, richtig/falsch или выбор.'
      : 'Dialogues and announcements: picture choice, true/false, or multiple choice.';
  String get subLesen => _ru
      ? 'Объявления, письма, таблички: richtig/falsch или сопоставление.'
      : 'Notices, letters, signs: true/false or matching.';
  String get subSprechen => _ru
      ? 'Знакомство (буквы, числа), тематические карточки, вежливые просьбы.'
      : 'Introduction (letters, numbers), topic cards, polite phrases.';
  String get subMix => _ru
      ? '30 случайных вопросов из всего пула (~1200+); ответы учитываются в статистике.'
      : '30 random questions from the full pool (~1200+); answers count toward stats.';
  String get subArtikel => _ru
      ? 'der / die / das: 335 слов, озвучка слова и полной формы.'
      : 'der / die / das: 335 words, word and full-form audio.';
  String get subAkkArtikel => _ru
      ? 'A1: теория + 100 заданий + бонус «Диалоги» (всего 112 карточек).'
      : 'A1: theory + 100 tasks + bonus dialogues (112 cards total).';
  String get subDatArtikel => _ru
      ? 'A1: теория + 150 заданий (Wem?, Präpositionen, Verben, Wo?, Plural).'
      : 'A1: theory + 150 tasks (Wem?, prepositions, verbs, Wo?, plural).';
  String get subPersAkk => _ru
      ? 'A1: теория + 150 заданий (mich, dich, ihn; Verben; Präpositionen).'
      : 'A1: theory + 150 tasks (mich, dich, ihn; verbs; prepositions).';
  String get subPersDat => _ru
      ? 'A1: теория + 150 заданий (mir, dir, ihm; Verben; Präpositionen).'
      : 'A1: theory + 150 tasks (mir, dir, ihm; verbs; prepositions).';
  String get subPossAkk => _ru
      ? 'A1: теория + 150 заданий (meinen Vater, meine Mutter, mein Kind …).'
      : 'A1: theory + 150 tasks (meinen Vater, meine Mutter, mein Kind …).';
  String get subPossNom => _ru
      ? 'A1: теория + 150 заданий (mein Vater, meine Mutter; alle Personen).'
      : 'A1: theory + 150 tasks (mein Vater, meine Mutter; all persons).';
  String get subPossNomAkk => _ru
      ? 'A1: теория + 150 заданий (mein / meinen, Wer? vs. Wen?).'
      : 'A1: theory + 150 tasks (mein / meinen, Wer? vs. Wen?).';
  String get subTrennbar => _ru
      ? 'A1: теория + 150 заданий (Präfix am Ende: aufstehen, anrufen, einkaufen …).'
      : 'A1: theory + 150 tasks (prefix at end: aufstehen, anrufen, einkaufen …).';

  // ——— Artikel (der/die/das) ———
  String get artikelAppBar => 'Artikel — der / die / das';
  String get artikelTheoryIntro => _ru
      ? 'Nominativ (A1): определённый артикль. Вторая вкладка — карточки: слово с переводом и выбор der / die / das.'
      : 'Nominative (A1): definite article. Second tab — word with translation and der / die / das choice.';
  String get artikelExerciseHint => _ru
      ? 'Под словом — перевод на русский. Выберите артикль. Динамик произносит только немецкое слово, без артикля. '
          'При ошибке карточка вернётся позже в очередь.'
      : 'Russian translation under the word. Choose the article. Audio plays the German word only, without the article. '
          'Wrong cards return to the queue later.';
  String get welcherArtikel => _ru ? 'Какой артикль?' : 'Which article?';
  String get antwort => _ru ? 'Ответ' : 'Answer';
  String get mitArtikel => _ru ? 'С артиклем' : 'With article';
  String wordListenTooltip(bool ohneArtikel) => ohneArtikel
      ? (_ru ? 'Слушать слово (без артикля)' : 'Listen to word (no article)')
      : (_ru ? 'Слушать ещё раз' : 'Listen again');
  String get listenHortext => _ru ? 'Слушать' : 'Listen';

  // ——— Grammar theory intros ———
  String get akkTheoryIntro => _ru
      ? 'Start Deutsch 1: bestimmte und unbestimmte Artikel, Präpositionen '
          '(für, durch, ohne, gegen, um). Вторая вкладка — упражнения.'
      : 'Start Deutsch 1: definite and indefinite articles, prepositions '
          '(für, durch, ohne, gegen, um). Second tab — exercises.';
  String get datTheoryIntro => _ru
      ? 'Start Deutsch 1: Wem?, Präpositionen, Verben, Wo? Вторая вкладка — 150 заданий.'
      : 'Start Deutsch 1: Wem?, prepositions, verbs, Wo? Second tab — 150 tasks.';
  String get persAkkTheoryIntro => _ru
      ? 'Start Deutsch 1: mich, dich, ihn … Вторая вкладка — 150 заданий.'
      : 'Start Deutsch 1: mich, dich, ihn … Second tab — 150 tasks.';
  String get persDatTheoryIntro => _ru
      ? 'Start Deutsch 1: mir, dir, ihm … Вторая вкладка — 150 заданий.'
      : 'Start Deutsch 1: mir, dir, ihm … Second tab — 150 tasks.';
  String get possAkkTheoryIntro => _ru
      ? 'Start Deutsch 1: meinen Vater, meine Mutter, mein Kind … 150 заданий.'
      : 'Start Deutsch 1: meinen Vater, meine Mutter, mein Kind … 150 tasks.';
  String get possNomTheoryIntro => _ru
      ? 'Start Deutsch 1: mein Vater, meine Mutter … Подлежащее — 150 заданий.'
      : 'Start Deutsch 1: mein Vater, meine Mutter … subject — 150 tasks.';
  String get possNomAkkTheoryIntro => _ru
      ? 'Wer/Was vs. Wen/Was, -en nur maskulin im Akk. — 150 заданий.'
      : 'Wer/Was vs. Wen/Was, -en only masculine in acc. — 150 tasks.';
  String get trennbarTheoryIntro => _ru
      ? 'Start Deutsch 1: приставка в конце предложения. Вторая вкладка — 150 заданий.'
      : 'Start Deutsch 1: prefix at end of clause. Second tab — 150 tasks.';
  String get bestimmterTheoryIntro => _ru
      ? 'Start Deutsch 1 — теория и сноска перед упражнениями (вторая вкладка).'
      : 'Start Deutsch 1 — theory and notes before exercises (second tab).';
  String get bestimmterDoneHint => _ru
      ? 'Сверьтесь с ключом в карточках заданий или пройдите снова.'
      : 'Check the key in task cards or try again.';
  String get bestimmterQueueHint => _ru
      ? 'Сначала при необходимости откройте вкладку «Теория».'
      : 'Open the Theory tab first if needed.';

  // ——— Mixed quiz ———
  String get mixAppBar => 'Mix — 30 Fragen (Grammatik)';
  String get mixTitle => moduleMixRu;
  String get mixIntro => _ru
      ? '30 случайных карточек из всего пула: der/die/das, артикли по падежам, '
          'местоимения, притяжательные артикли, отделяемые глаголы. Каждый запуск — '
          'новая случайная подборка.'
      : '30 random cards from the full pool: der/die/das, case articles, '
          'pronouns, possessives, separable verbs. Each run is a new random set.';
  String get mixCumulativeTitle => _ru ? 'Накопленно по модулям' : 'Cumulative by module';
  String mixCumulativeLine(MixedQuizModule m, int right, int wrong) =>
      '${mixedQuizModuleLabel(m)}: ${_ru ? 'верно' : 'correct'} $right, '
      '${_ru ? 'неверно' : 'wrong'} $wrong';
  String get mixNoData =>
      _ru ? 'Пока нет данных — пройдите первый микс.' : 'No data yet — complete your first mix.';
  String get mixStartButton => '30 Fragen starten';
  String get mixSessionDone => _ru ? 'Сессия завершена' : 'Session complete';
  String get mixBackToStart => _ru ? 'К началу' : 'Back to start';
  String mixChipLabel(String moduleDe, int nr, int left) => _ru
      ? '$moduleDe · № $nr · осталось $left'
      : '$moduleDe · No. $nr · $left left';

  String mixedQuizModuleLabel(MixedQuizModule m) {
    if (_ru) return mixedQuizModuleLabelRu(m);
    return mixedQuizModuleLabelDe(m);
  }

  // ——— Главный экран: статистика и рекомендации ———
  String moduleAnswersLine(int total, int percent) => _ru
      ? '$total ответов · $percent% верно'
      : '$total answers · $percent% correct';

  String get homeRecoTitle => _ru ? 'Рекомендация' : 'Recommendation';

  String homeRecommendationHeader(List<String> tips) {
    final buf = StringBuffer('${_ru ? 'Стоит подтянуть' : 'Focus on'}:\n');
    for (final t in tips) {
      buf.writeln('• $t');
    }
    return buf.toString().trim();
  }

  String moduleTitleForStats(GrammarStatsModule m) => switch (m) {
        GrammarStatsModule.mix => moduleMixRu,
        GrammarStatsModule.derDieDas => moduleArtikelRu,
        GrammarStatsModule.akkusativArtikel => moduleAkkArtikelRu,
        GrammarStatsModule.dativArtikel => moduleDatArtikelRu,
        GrammarStatsModule.personalpronomenAkkusativ => modulePersAkkRu,
        GrammarStatsModule.personalpronomenDativ => modulePersDatRu,
        GrammarStatsModule.possessivartikelAkkusativ => modulePossAkkRu,
        GrammarStatsModule.possessivartikelNominativ => modulePossNomRu,
        GrammarStatsModule.possessivartikelNomAkk => modulePossNomAkkRu,
        GrammarStatsModule.trennbareVerben => moduleTrennbarRu,
      };

  String recommendModuleWeak(GrammarStatsModule m) => _ru
      ? 'Чаще всего ошибки в теме «${moduleTitleForStats(m)}».'
      : 'Most mistakes in «${moduleTitleForStats(m)}».';

  String recommendDerDieDasTag(String tag) {
    final gender = switch (tag) {
      'der' => _ru ? 'мужской род (der)' : 'masculine (der)',
      'die' => _ru ? 'женский род (die)' : 'feminine (die)',
      'das' => _ru ? 'средний род (das)' : 'neuter (das)',
      _ => tag,
    };
    return _ru
        ? 'Артикли der/die/das: чаще путаете $gender.'
        : 'Articles der/die/das: review $gender.';
  }

  String recommendAkkusativTag(String tag) => _ru
      ? 'Винительный падеж: повторите форму «$tag».'
      : 'Accusative: review the form «$tag».';

  String recommendDativTag(String tag) => _ru
      ? 'Дательный падеж: повторите форму «$tag».'
      : 'Dative: review the form «$tag».';

  String sessionRecommendation(Map<MixedQuizModule, int> wrongByModule) {
    final bad = wrongByModule.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (bad.isEmpty) {
      return _ru
          ? 'В этой сессии ошибок по темам нет — отличный результат.'
          : 'No topic errors in this session — great result.';
    }
    final buf = StringBuffer(
      _ru ? 'Рекомендуем повторить:\n' : 'We recommend reviewing:\n',
    );
    for (final e in bad.take(4)) {
      buf.writeln(_ru
          ? '• ${mixedQuizModuleLabel(e.key)} — ошибок в этом проходе: ${e.value}'
          : '• ${mixedQuizModuleLabel(e.key)} — errors this run: ${e.value}');
    }
    buf.write(_ru
        ? '\nПовторите эти темы в отдельных разделах или запустите микс снова.'
        : '\nReview these topics in their sections or run the mix again.');
    return buf.toString();
  }

  // ——— Hören ———
  String get hoerenAppBar => _ru ? 'Hören — Аудирование' : 'Hören — Listening';
  String get hoerenIntro => _ru
      ? 'Задания из Teil 1–3 и бонус — в случайном порядке. У каждого задания шесть подвопросов '
          '(картинки: шесть раундов A–B–C; richtig/falsch — шесть утверждений; бонус — шесть блоков). '
          'Слушайте текст (play), затем отвечайте. Пунктир — перевод слова. '
          'В A–B–C нажмите круг с буквой слева. '
          'Случайный котик в конце — только если за всю серию нет ни одной ошибки '
          'ни в шести вопросах A–C, ни в шести richtig/falsch (бонус без оценки на кота не влияет).'
      : 'Tasks from Teil 1–3 and bonus — shuffled. Each task has six sub-questions '
          '(pictures: six A–B–C rounds; true/false: six statements; bonus: six blocks). '
          'Listen (play), then answer. Dotted underline — word translation. '
          'For A–B–C tap the letter circle on the left. '
          'Random cat at the end — only if you make no mistakes in six A–C or six true/false '
          '(bonus does not affect the cat).';
  String get hoerenShuffleHint => _ru
      ? 'Нажмите «shuffle» на панели сверху, чтобы пройти те же задания в новом порядке.'
      : 'Tap shuffle in the app bar to run the same tasks in a new order.';
  String hoerenCatPerfect(int n) => _ru
      ? 'Случайный котик — за серию из $n заданий без единой ошибки '
          'в блоках A–C и richtig/falsch.'
      : 'Random cat — for a run of $n tasks with no mistakes in A–C and true/false blocks.';
  String get hoerenCatTitle =>
      _ru ? 'Котик только при идеальном результате' : 'Cat only for a perfect run';
  String get hoerenCatMissed => _ru
      ? 'Была хотя бы одна ошибка в шести вопросах с картинками (A–B–C) '
          'или в шести утверждениях richtig/falsch. Пройдите серию снова '
          '(shuffle) и ответьте на всё верно — тогда появится случайный кот.'
      : 'At least one mistake in six picture (A–B–C) or six true/false questions. '
          'Run the series again (shuffle) with all correct — then a random cat appears.';
  String ttsError(String msg) => _ru ? 'Озвучка: $msg' : 'Audio: $msg';
  String get hoerenLinuxTts => _ru
      ? 'На Linux нужен синтез речи: установите пакет espeak-ng '
          '(например: sudo apt install espeak-ng).'
      : 'On Linux install speech synthesis: espeak-ng package '
          '(e.g. sudo apt install espeak-ng).';
  String frageLabel(int current, int total) =>
      _ru ? 'Вопрос $current/$total' : 'Question $current/$total';
  String get rundeZuEnde => _ru ? 'Раунд завершён' : 'Round complete';
  String get richtigOderFalsch => _ru ? 'Верно или неверно?' : 'True or false?';
  String get zumUeben => _ru ? 'Для практики (не формат экзамена)' : 'For practice (not exam format)';

  // ——— Lesen ———
  String get lesenAppBar => _ru ? 'Lesen — Чтение' : 'Lesen — Reading';
  String get lesenIntro => _ru
      ? 'Здесь вы читаете объявления, письма и таблички и отвечаете «richtig» или «falsch», '
          'либо сопоставляете текст и ситуацию. Ниже можно прочитать фразу вслух в микрофон — '
          'приложение сравнит распознанный текст с эталоном (Android / iOS; на Linux обычно недоступно).'
      : 'Read notices, letters, and signs and answer «richtig» or «falsch», '
          'or match text and situation. Below you can read a sentence aloud — '
          'the app compares recognition to the reference (Android / iOS; usually unavailable on Linux).';
  String get lesenSpeechUnavailable => _ru
      ? 'Распознавание речи недоступно на этой платформе или нет языка «de» в системе. '
          'Попробуйте Android / iOS и установите немецкий для ввода речи в настройках.'
      : 'Speech recognition is unavailable on this platform or German (de) is missing. '
          'Try Android / iOS and install German for speech input in settings.';
  String get lesenMicHint => _ru
      ? 'Нажмите микрофон и прочитайте предложение. Остановка — снова на кнопку.'
      : 'Tap the microphone and read the sentence. Tap again to stop.';
  String get aussage => _ru ? 'Утверждение' : 'Statement';
  String get istAussageRichtig =>
      _ru ? 'Верно ли утверждение?' : 'Is the statement correct?';
  String get lautLesen => _ru ? 'Читать вслух' : 'Read aloud';
  String get stopp => _ru ? 'Стоп' : 'Stop';
  String get aufnehmen => _ru ? 'Запись' : 'Record';
  String get erkannt => _ru ? 'Распознано:' : 'Recognized:';
  String uebereinstimmung(int percent) => _ru
      ? 'Совпадение: $percent% (только грубая оценка, не оценка экзамена).'
      : 'Match: $percent% (rough estimate only, not exam grading).';
  String speechError(String msg) =>
      _ru ? 'Распознавание речи: $msg' : 'Speech recognition: $msg';
  String get lesenCorrectSnack => _ru ? 'Верно — хорошо прочитано!' : 'Correct — well read!';
  String lesenRetrySnack(String expected) =>
      _ru ? 'Ещё раз: $expected' : 'Try again: $expected';
  String get lesenMicError => _ru
      ? 'Микрофон / распознавание речи недоступны.'
      : 'Microphone / speech recognition unavailable.';
  String get lesenInstructionDe =>
      'Lesen Sie die Texte (Aushänge, Briefe, Schilder). '
      'Entscheiden Sie: richtig oder falsch — oder ordnen Sie Text und Situation zu.';
  String get lesenCheckWrongSnack =>
      _ru
          ? 'Ещё раз: в тексте в субботу «geschlossen».'
          : 'Try again: the text says "geschlossen" on Saturday.';
  String get lesenAnswerGood => _ru ? 'Отлично!' : 'Very good!';
  String get lesenAnswerHint =>
      _ru ? 'Подсказка: перечитайте первое предложение.' : 'Tip: read the first sentence again.';
  String get speechMatchHigh => _ru
      ? 'Близко к тексту — так держать!'
      : 'Close to the text — keep going!';
  String get speechMatchMid => _ru
      ? 'Уже неплохо — попробуйте ещё раз чётче.'
      : 'Getting there — try again a bit clearer.';
  String get speechMatchLow => _ru
      ? 'Много отличий — читайте медленнее и запишите снова.'
      : 'Quite different — read slower and record again.';

  // ——— Sprechen ———
  String get sprechenAppBar => _ru ? 'Sprechen — Говорение' : 'Sprechen — Speaking';
  String get sprechenTeil1Title => _ru ? 'Teil 1 — Знакомство' : 'Teil 1 — Introduction';
  String get sprechenTeil2Title => _ru ? 'Teil 2 — Themenkarten' : 'Teil 2 — Topic cards';
  String get sprechenTeil3Title =>
      _ru ? 'Teil 3 — Höfliche Bitten / Formeln' : 'Teil 3 — Polite requests / phrases';
  String get sprechenTeil1Hint => _ru
      ? 'Эта часть: знакомство (буквы по алфавиту, числа — телефон, время, цена).'
      : 'This part: introduction (spelling, numbers — phone, time, price).';
  String get sprechenTeil2Hint => _ru
      ? 'Карточки с вопросами: короткий связный монолог по теме.'
      : 'Topic cards: short coherent monologue on the theme.';
  String get sprechenTeil3Hint => _ru
      ? 'Вежливые просьбы и устойчивые формулы в типичных ситуациях.'
      : 'Polite requests and set phrases in typical situations.';

  // ——— Tappable Hörtext ———
  String get translationLoading => _ru ? 'Запрашиваем перевод…' : 'Fetching translation…';
  String get translationOnlineNote => _ru
      ? 'Перевод из интернета (MyMemory), может быть неточным.'
      : 'Online translation (MyMemory), may be inaccurate.';
  String get translationFailed => _ru
      ? 'Не удалось получить перевод (сеть или лимит сервиса). '
          'Можно добавить слово в словарь приложения или в wordHints у задания.'
      : 'Could not fetch translation (network or service limit). '
          'Add the word to the app glossary or task wordHints.';
  String get retry => _ru ? 'Повторить' : 'Retry';
  String get pronunciationNote => _ru
      ? 'Произношение при открытии. Нет в словаре — пробуем перевод онлайн.'
      : 'Pronunciation on open. Not in glossary — trying online translation.';

  // ——— Feedback (artikel stats) ———
  ({String sterne, String meldung}) artikelFeedback(
    int prozent,
    ArtikelStatsModul modul,
  ) {
    if (prozent >= 90) {
      return (
        sterne: '⭐⭐⭐',
        meldung: _expertMessage(modul),
      );
    }
    if (prozent >= 80) {
      return (
        sterne: '⭐⭐',
        meldung: _ru
            ? 'Очень хорошо. Несколько мелких ошибок.'
            : 'Very good. A few small mistakes.',
      );
    }
    if (prozent >= 70) {
      return (
        sterne: '⭐',
        meldung: _ru
            ? 'Хорошо. Повторите мужской род.'
            : 'Good. Review masculine gender.',
      );
    }
    if (prozent >= 60) {
      return (
        sterne: '⚠️',
        meldung: _ru
            ? 'Средне. Учите таблицу артиклей.'
            : 'Fair. Study the article table.',
      );
    }
    return (
      sterne: '🔄',
      meldung: _ru ? 'Нужно повторить теорию.' : 'Review the theory.',
    );
  }

  String _expertMessage(ArtikelStatsModul modul) {
    if (_ru) {
      return switch (modul) {
        ArtikelStatsModul.akkusativ =>
          'Эксперт A1! Вы идеально знаете Akkusativ.',
        ArtikelStatsModul.dativ =>
          'Эксперт A1! Вы отлично знаете Artikel im Dativ.',
        ArtikelStatsModul.nominativDerDieDas =>
          'Эксперт A1! Вы отлично знаете der / die / das в Nominativ.',
        ArtikelStatsModul.personalpronomenAkkusativ =>
          'Эксперт A1! Personalpronomen im Akkusativ — ваша сильная сторона.',
        ArtikelStatsModul.personalpronomenDativ =>
          'Эксперт A1! Dativ-местоимения — ваша сильная сторона.',
        ArtikelStatsModul.possessivartikelAkkusativ =>
          'Эксперт A1! Possessivartikel im Akkusativ — отлично.',
        ArtikelStatsModul.possessivartikelNominativ =>
          'Эксперт A1! Possessivartikel im Nominativ — отлично.',
        ArtikelStatsModul.possessivartikelNomAkk =>
          'Эксперт A1! Вы отлично различаете Nom. и Akk. у притяжательных артиклей.',
        ArtikelStatsModul.trennbareVerben =>
          'Эксперт A1! Отделяемые глаголы и порядок слов — ваша сильная сторона.',
      };
    }
    return switch (modul) {
      ArtikelStatsModul.akkusativ =>
        'A1 expert! Accusative articles — excellent.',
      ArtikelStatsModul.dativ =>
        'A1 expert! Dative articles — excellent.',
      ArtikelStatsModul.nominativDerDieDas =>
        'A1 expert! der / die / das in nominative — excellent.',
      ArtikelStatsModul.personalpronomenAkkusativ =>
        'A1 expert! Accusative personal pronouns — strong area.',
      ArtikelStatsModul.personalpronomenDativ =>
        'A1 expert! Dative pronouns — strong area.',
      ArtikelStatsModul.possessivartikelAkkusativ =>
        'A1 expert! Possessive articles in accusative — excellent.',
      ArtikelStatsModul.possessivartikelNominativ =>
        'A1 expert! Possessive articles in nominative — excellent.',
      ArtikelStatsModul.possessivartikelNomAkk =>
        'A1 expert! Nom. vs. acc. possessives — excellent.',
      ArtikelStatsModul.trennbareVerben =>
        'A1 expert! Separable verbs and word order — strong area.',
    };
  }
}
