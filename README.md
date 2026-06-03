# Deutsch A1 Start

Flutter-приложение для подготовки к **Start Deutsch 1 / A1**: аудирование, чтение, говорение и грамматические блоки.

## Quick start

1. **Automatic installation**:
```bash
** Make the script executable **
chmod +x setup.sh

** Start the installation **
./setup.sh
```

2. **Manual installation**:
```bash
   ** Clone the repository**
   git clone https://github.com/evgeniygazetdinov/test_DEUTSCH_start.git
   cd test_DEUTSCH_start

   ** Install dependencies**
   flutter pub get

   ** build an APK**
   flutter build apk --release
   <ins> apk path build/app/outputs/flutter-apk/app-release.apk </ins>

   ** run on device**
   flutter run
```


## Модули

**Экзаменационные части**

- **Hören** — аудирование (картинки, richtig/falsch, выбор)
- **Lesen** — чтение (richtig/falsch, сопоставление)
- **Sprechen** — говорение (знакомство, темы, вежливые формулы)

**Грамматика (A1)**

- **Artikel** — der / die / das в именительном падеже
- **Artikel im Akkusativ** — артикль в винительном падеже
- **Artikel im Dativ** — артикль в дательном падеже
- **Personalpronomen — Akkusativ / Dativ** — личные местоимения
- **Possessivartikel** — притяжательные артикли (Akk., Nom., сравнение Nom. vs Akk.)
- **Trennbare Verben** — отделяемые глаголы (Präfix в конце предложения)
