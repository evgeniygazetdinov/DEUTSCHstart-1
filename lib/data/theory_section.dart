import '../l10n/app_locale.dart';

/// Секция теории с русским и английским текстом.
class TheorySection {
  const TheorySection({
    required this.titleRu,
    required this.bodyRu,
    required this.titleEn,
    required this.bodyEn,
  });

  final String titleRu;
  final String bodyRu;
  final String titleEn;
  final String bodyEn;

  String title(AppLanguage lang) =>
      lang == AppLanguage.ru ? titleRu : titleEn;

  String body(AppLanguage lang) =>
      lang == AppLanguage.ru ? bodyRu : bodyEn;
}
