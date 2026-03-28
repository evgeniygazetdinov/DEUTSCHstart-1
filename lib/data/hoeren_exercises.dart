import 'dart:math';

part 'hoeren_bulk_exercises.dart';

/// Упражнения Hören (A1): выбор картинки / richtig–falsch / открытые вопросы (Bonus).
sealed class HoerenExercise {
  const HoerenExercise({
    required this.teil,
    required this.title,
    required this.hortext,
    this.wordHints = const {},
  });

  final String teil;
  final String title;

  /// Текст диалога или объявления (экран + озвучка).
  final String hortext;

  /// Доп. переводы к этому тексту (ключ — нормализованное слово).
  final Map<String, String> wordHints;
}

/// Три варианта A–C (подписи с эмодзи).
final class HoerenPictureExercise extends HoerenExercise {
  const HoerenPictureExercise({
    required super.teil,
    required super.title,
    required super.hortext,
    super.wordHints = const {},
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

/// Несколько утверждений richtig / falsch к одному Hörtext.
final class HoerenRichtigFalschExercise extends HoerenExercise {
  const HoerenRichtigFalschExercise({
    required super.teil,
    required super.title,
    required super.hortext,
    super.wordHints = const {},
    required this.items,
  });

  final List<HoerenRfItem> items;
}

final class HoerenRfItem {
  const HoerenRfItem({
    required this.statement,
    required this.correctIsRichtig,
    required this.explanation,
  });

  final String statement;

  /// Правильный ответ: «richtig» (true) или «falsch» (false).
  final bool correctIsRichtig;
  final String explanation;
}

/// Bonus: ключевые слова, ответы для самопроверки.
final class HoerenOpenExercise extends HoerenExercise {
  const HoerenOpenExercise({
    required super.teil,
    required super.title,
    required super.hortext,
    super.wordHints = const {},
    required this.qa,
  });

  final List<HoerenOpenQa> qa;
}

final class HoerenOpenQa {
  const HoerenOpenQa({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Все задания в исходном порядке (перемешивание на экране).
List<HoerenExercise> allHoerenExercises() {
  return [
    const HoerenPictureExercise(
      teil: 'Teil 1',
      title: 'Was kauft die Frau?',
      hortext:
          'Mann: Guten Morgen! Was darf es sein? '
          'Frau: Ich hätte gerne ein Brötchen und einen Kaffee. Ach, und bitte noch eine Zeitung.',
      question: 'Was kauft die Frau?',
      options: [
        'A) 🥖🍞 nur Brot',
        'B) ☕📰 Kaffee und Zeitung',
        'C) 🥖☕📰 Brötchen, Kaffee und Zeitung',
      ],
      correctIndex: 2,
      explanation:
          'Sie sagt: Brötchen, Kaffee und Zeitung — alle drei Dinge.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 1',
      title: 'Was hat die Frau?',
      hortext:
          'Mann: Du siehst müde aus. Was ist los? '
          'Frau: Ich habe Kopfschmerzen und mein Rücken tut weh. Ich gehe heute früher nach Hause.',
      question: 'Was hat die Frau?',
      options: [
        'A) 🤕 Kopfschmerzen',
        'B) 🤒 Fieber',
        'C) 🤕 Rückenschmerzen (Kopf und Rücken)',
      ],
      correctIndex: 2,
      explanation: 'Sie nennt Kopfschmerzen und Rückenschmerzen.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 1',
      title: 'Wann fährt der Zug?',
      hortext:
          'Achtung, Fahrgäste. Der ICE nach München fährt um 14:45 Uhr ab. '
          'Leider hat der Zug 10 Minuten Verspätung.',
      question: 'Wann fährt der Zug?',
      options: [
        'A) 14:35 Uhr',
        'B) 14:45 Uhr',
        'C) 14:55 Uhr',
      ],
      correctIndex: 2,
      explanation: 'Plan: 14:45, plus 10 Minuten Verspätung = 14:55.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 1',
      title: 'Wo findet das Gespräch statt?',
      hortext:
          'Frau: Was kostet die Hose? '
          'Mann: 49,90 Euro. Möchten Sie sie anprobieren? '
          'Frau: Ja, gerne. Wo sind die Umkleidekabinen?',
      question: 'Wo sind die Personen?',
      options: [
        'A) 🛒 Supermarkt',
        'B) 👗 Bekleidungsgeschäft',
        'C) 🍽️ Restaurant',
      ],
      correctIndex: 1,
      explanation: 'Hose, anprobieren, Umkleidekabine → Kleidungsgeschäft.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 1',
      title: 'Was macht der Mann?',
      hortext:
          'Frau: Hallo, bist du beschäftigt? '
          'Mann: Ja, ich muss noch zwei E-Mails schreiben und dann einen Termin vorbereiten.',
      question: 'Was macht der Mann gerade?',
      options: [
        'A) Er telefoniert.',
        'B) Er arbeitet am Computer.',
        'C) Er isst zu Mittag.',
      ],
      correctIndex: 1,
      explanation: 'E-Mails und Termin vorbereiten → Büroarbeit am PC.',
    ),
    const HoerenRichtigFalschExercise(
      teil: 'Teil 2',
      title: 'Ansage im Supermarkt',
      hortext:
          'Liebe Kunden, unser Supermarkt hat heute von 8:00 bis 20:00 Uhr geöffnet. '
          'Die Mittagspause ist von 13:00 bis 14:00 Uhr. Vielen Dank für Ihren Einkauf.',
      items: [
        HoerenRfItem(
          statement: 'Der Supermarkt hat bis 20:00 Uhr geöffnet.',
          correctIsRichtig: true,
          explanation: 'Im Text: bis 20:00 Uhr geöffnet.',
        ),
        HoerenRfItem(
          statement: 'Von 12:00 bis 13:00 Uhr ist Pause.',
          correctIsRichtig: false,
          explanation: 'Pause ist von 13:00 bis 14:00 Uhr.',
        ),
      ],
    ),
    const HoerenRichtigFalschExercise(
      teil: 'Teil 2',
      title: 'Durchsage am Flughafen',
      hortext:
          'Achtung, Flug LH 432 nach Wien. Der Flug wird von Gate B12 durchgeführt. '
          'Das Boarding beginnt um 15:20 Uhr. Flug LH 432 nach Wien, Gate B12.',
      items: [
        HoerenRfItem(
          statement: 'Der Flug geht nach Berlin.',
          correctIsRichtig: false,
          explanation: 'Der Flug geht nach Wien.',
        ),
        HoerenRfItem(
          statement: 'Das Boarding ist um 15:20 Uhr.',
          correctIsRichtig: true,
          explanation: 'Boarding beginnt um 15:20 Uhr.',
        ),
      ],
    ),
    const HoerenRichtigFalschExercise(
      teil: 'Teil 2',
      title: 'Telefonansage (Arztpraxis)',
      hortext:
          'Sie erreichen die Praxis von Dr. Weber. Wir sind montags bis freitags von 8:00 bis 12:00 Uhr '
          'und montags, dienstags und donnerstags von 15:00 bis 18:00 Uhr geöffnet. '
          'Mittwoch nachmittag geschlossen.',
      items: [
        HoerenRfItem(
          statement: 'Die Praxis hat am Mittwoch nachmittag geschlossen.',
          correctIsRichtig: true,
          explanation: 'Mittwoch nachmittag geschlossen.',
        ),
        HoerenRfItem(
          statement: 'Am Freitag nachmittag ist geöffnet.',
          correctIsRichtig: false,
          explanation: 'Freitag nur bis 12:00, kein Nachmittag in der Liste.',
        ),
      ],
    ),
    const HoerenPictureExercise(
      teil: 'Teil 3',
      title: 'Wohin fährt die Familie?',
      hortext:
          'Vater: Kinder, packt die Badesachen ein! '
          'Tochter: Papa, fahren wir an den See? '
          'Vater: Nein, wir fahren ans Meer. Das Wetter ist super. '
          'Mutter: Und nach dem Strand essen wir Eis.',
      question: 'Wohin fährt die Familie?',
      options: [
        'A) 🏔️ In die Berge',
        'B) 🌊 Ans Meer',
        'C) 🏊 Ins Schwimmbad',
      ],
      correctIndex: 1,
      explanation: 'Ans Meer, Badesachen, Strand → Meer.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 3',
      title: 'Was ist das Problem?',
      hortext:
          'Mann: Entschuldigung, ich habe eine Frage. '
          'Frau: Ja, bitte? '
          'Mann: Ich habe hier ein Zimmer reserviert für zwei Nächte. Aber das Zimmer ist sehr laut. Direkt neben der Straße. '
          'Frau: Das tut mir leid. Wir haben noch ein Zimmer im dritten Stock. Das ist ruhiger.',
      question: 'Was ist das Problem?',
      options: [
        'A) Das Zimmer ist zu klein.',
        'B) Das Zimmer ist zu teuer.',
        'C) Das Zimmer ist zu laut.',
      ],
      correctIndex: 2,
      explanation: 'Er sagt: Das Zimmer ist sehr laut.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 3',
      title: 'Was macht der Mann am Sonntag?',
      hortext:
          'Frau: Was machst du am Wochenende? '
          'Mann: Am Samstag habe ich keine Zeit, ich muss arbeiten. Aber am Sonntag will ich mit Freunden ins Kino. Ein neuer Film mit Brad Pitt. '
          'Frau: Klingt gut!',
      question: 'Was macht der Mann am Sonntag?',
      options: [
        'A) Er arbeitet.',
        'B) Er geht ins Kino.',
        'C) Er trifft Freunde im Café.',
      ],
      correctIndex: 1,
      explanation: 'Am Sonntag ins Kino.',
    ),
    const HoerenPictureExercise(
      teil: 'Teil 3',
      title: 'Welches Zimmer nimmt der Gast?',
      hortext:
          'Gast: Ich möchte ein Einzelzimmer für drei Nächte, bitte. '
          'Rezeptionist: Wir haben Zimmer 14 im ersten Stock zur Straße, oder Zimmer 22 im zweiten Stock zum Hof. Beide kosten 65 Euro pro Nacht. '
          'Gast: Ich nehme das Zimmer zum Hof. Das ist ruhiger.',
      question: 'Welches Zimmer nimmt der Gast?',
      options: [
        'A) Zimmer 14, 1. Stock',
        'B) Zimmer 22, 2. Stock',
        'C) Zimmer 22, 1. Stock',
      ],
      correctIndex: 1,
      explanation: 'Zimmer zum Hof = Zimmer 22, zweiter Stock.',
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Im Restaurant',
      hortext:
          'Kellner: Guten Abend, was darf ich Ihnen bringen? '
          'Gast: Ich nehme die Schnitzel mit Pommes und einen Salat. '
          'Kellner: Und zu trinken? '
          'Gast: Ein Glas Weißwein, bitte.',
      qa: [
        HoerenOpenQa(
          question: 'Was isst der Gast?',
          answer: 'Schnitzel mit Pommes und Salat.',
        ),
        HoerenOpenQa(
          question: 'Was trinkt er?',
          answer: 'Weißwein.',
        ),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Auf der Arbeit',
      hortext:
          'Chef: Frau Müller, wo ist der Bericht? '
          'Frau Müller: Der Bericht ist noch nicht fertig. Ich habe heute Vormittag einen Termin beim Kunden. '
          'Chef: Wann ist der Bericht fertig? '
          'Frau Müller: Am Nachmittag, etwa um 15 Uhr.',
      qa: [
        HoerenOpenQa(
          question: 'Was macht Frau Müller am Vormittag?',
          answer: 'Sie hat einen Termin beim Kunden.',
        ),
        HoerenOpenQa(
          question: 'Wann ist der Bericht fertig?',
          answer: 'Am Nachmittag, etwa um 15 Uhr.',
        ),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Verabredung',
      hortext:
          'Anna: Hallo Tom, hast du am Freitagabend Zeit? '
          'Tom: Ja, was hast du vor? '
          'Anna: Lass uns ins Kino gehen. Um 20 Uhr läuft ein neuer Film. '
          'Tom: Super! Treffen wir uns um 19:30 Uhr vor dem Kino? '
          'Anna: Ja, passt. Bis dann!',
      qa: [
        HoerenOpenQa(
          question: 'Wann treffen sich die beiden?',
          answer: 'Um 19:30 Uhr.',
        ),
        HoerenOpenQa(
          question: 'Wo treffen sie sich?',
          answer: 'Vor dem Kino.',
        ),
        HoerenOpenQa(
          question: 'Was machen sie?',
          answer: 'Sie gehen ins Kino.',
        ),
      ],
    ),
    ...hoerenBulkExtras(),
  ];
}

/// Копия списка в случайном порядке.
List<HoerenExercise> shuffledHoerenExercises(Random random) {
  final list = List<HoerenExercise>.from(allHoerenExercises());
  list.shuffle(random);
  return list;
}
