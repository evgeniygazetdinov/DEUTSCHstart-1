/// ID рекламных блоков Яндекс Рекламной сети.
///
/// Создайте баннер в https://partner.yandex.ru и подставьте свой adUnitId
/// в [productionBannerAdUnitId].
abstract final class YandexAdsConfig {
  /// Тестовый блок Яндекса (для проверки интеграции).
  static const demoBannerAdUnitId = 'demo-banner-yandex';

  /// Боевой баннер — замените на свой R-M-… из кабинета.
  static const productionBannerAdUnitId = 'R-M-0000000-1';

  static String get bannerAdUnitId => productionBannerAdUnitId;
}
