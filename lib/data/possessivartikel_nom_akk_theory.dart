import 'theory_section.dart';

/// Теория: Possessivartikel Nominativ vs. Akkusativ (A1 / Start Deutsch 1).
const List<TheorySection> kPossessivartikelNomAkkTheorySections = [
  TheorySection(
    titleRu: '1. Что нужно знать?',
    titleEn: '1. What do you need to know?',
    bodyRu:
        'Nominativ (Wer?/Was?) — подлежащее.\n'
        'Akkusativ (Wen?/Was?) — прямое дополнение.\n\n'
        'Possessivartikel меняются вместе с падежом.',
    bodyEn:
        'Nominative (Wer?/Was?) — the subject.\n'
        'Accusative (Wen?/Was?) — the direct object.\n\n'
        'Possessive articles change with the case.',
  ),
  TheorySection(
    titleRu: '2. Таблица: Nom. vs. Akk. (ich)',
    titleEn: '2. Table: Nom. vs. Acc. (ich)',
    bodyRu:
        '\tMask.\tFem.\tNeut.\tPl.\n'
        'Nom.\tmein\tmeine\tmein\tmeine\n'
        'Akk.\tmeinen\tmeine\tmein\tmeine\n\n'
        'То же правило для dein, sein, ihr, unser, euer, ihr (они), Ihr.',
    bodyEn:
        '\tMasc.\tFem.\tNeut.\tPl.\n'
        'Nom.\tmein\tmeine\tmein\tmeine\n'
        'Acc.\tmeinen\tmeine\tmein\tmeine\n\n'
        'The same rule for dein, sein, ihr, unser, euer, ihr (they), Ihr.',
  ),
  TheorySection(
    titleRu: '3. Главное правило',
    titleEn: '3. Main rule',
    bodyRu:
        'Только мужской род (der) в Akkusativ: -en (meinen Vater).\n'
        'Женский, средний, мн.ч.: в Akk. как в Nom.',
    bodyEn:
        'Only masculine (der) in accusative: -en (meinen Vater).\n'
        'Feminine, neuter, plural: accusative same as nominative.',
  ),
  TheorySection(
    titleRu: '4. Как определить падеж?',
    titleEn: '4. How to tell the case?',
    bodyRu:
        'Подлежащее → Nom. (Mein Hund schläft.)\n'
        'После sehen, lieben, haben, kaufen … → Akk. (Ich sehe meinen Hund.)\n'
        'После für, durch, ohne, gegen, um → Akk.',
    bodyEn:
        'Subject → Nom. (Mein Hund schläft.)\n'
        'After sehen, lieben, haben, kaufen … → Acc. (Ich sehe meinen Hund.)\n'
        'After für, durch, ohne, gegen, um → Acc.',
  ),
  TheorySection(
    titleRu: '5. Типичные ошибки',
    titleEn: '5. Typical mistakes',
    bodyRu:
        '❌ Ich sehe mein Vater.  ✅ meinen (m. Akk.)\n'
        '❌ Meinen Mutter ist nett.  ✅ Meine (f. Nom.)\n'
        '❌ Deinen Bruder kommt.  ✅ Dein (m. Nom.)',
    bodyEn:
        '❌ Ich sehe mein Vater.  ✅ meinen (m. Acc.)\n'
        '❌ Meinen Mutter ist nett.  ✅ Meine (f. Nom.)\n'
        '❌ Deinen Bruder kommt.  ✅ Dein (m. Nom.)',
  ),
  TheorySection(
    titleRu: '6. Итоговая шкала (150 вопросов)',
    titleEn: '6. Final scale (150 questions)',
    bodyRu:
        '140–150\t⭐⭐⭐ Отлично различаете Nom. и Akk.\n'
        '120–129\t⭐ Повторите -en в Akk. (муж. род).\n'
        'Меньше 90\t📖 Теория заново.',
    bodyEn:
        '140–150\t⭐⭐⭐ You clearly distinguish Nom. and Acc.\n'
        '120–129\t⭐ Review -en in Acc. (masculine).\n'
        'Below 90\t📖 Theory from scratch.',
  ),
  TheorySection(
    titleRu: '7. Шпаргалка',
    titleEn: '7. Cheat sheet',
    bodyRu:
        'NOM: mein/meine (m+f/n+pl по правилу +e)\n'
        'AKK: meinen (только m.) · остальное как в Nom.',
    bodyEn:
        'NOM: mein/meine (m+f/n+pl by the +e rule)\n'
        'ACC: meinen (m. only) · everything else as in Nom.',
  ),
];
