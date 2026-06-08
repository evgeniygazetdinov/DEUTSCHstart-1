/// Шаблон секретов Яндекс-рекламы.
///
/// Скопируйте в `yandex_ads_secrets.dart` (этот файл в .gitignore):
///   cp lib/config/yandex_ads_secrets.example.dart lib/config/yandex_ads_secrets.dart
///
/// Либо задайте при сборке (CI / без файла):
///   flutter build apk --dart-define=YANDEX_BANNER_AD_UNIT_ID=R-M-…
///   flutter build apk --dart-define=YANDEX_INTERSTITIAL_AD_UNIT_ID=R-M-…
abstract final class YandexAdsSecrets {
  /// Боевой баннер из https://partner.yandex.ru — оставьте '' для демо.
  static const bannerAdUnitId = '';

  /// Полноэкранный блок — оставьте '' пока нет ID.
  static const interstitialAdUnitId = '';
}
