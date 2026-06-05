import 'package:flutter/foundation.dart';

/// ID рекламных блоков Яндекс Рекламной сети.
///
/// Создайте блоки в https://partner.yandex.ru и подставьте свои R-M-… в
/// [productionBannerAdUnitId] и [productionInterstitialAdUnitId].
abstract final class YandexAdsConfig {
  static const demoBannerAdUnitId = 'demo-banner-yandex';
  static const demoInterstitialAdUnitId = 'demo-interstitial-yandex';

  /// Боевой баннер — замените на свой R-M-… из кабинета.
  static const productionBannerAdUnitId = 'R-M-0000000-1';

  /// Боевой полноэкранный блок — замените на свой R-M-… из кабинета.
  static const productionInterstitialAdUnitId = 'R-M-0000000-2';

  static bool get _hasProductionBanner =>
      productionBannerAdUnitId != 'R-M-0000000-1';

  static bool get _hasProductionInterstitial =>
      productionInterstitialAdUnitId != 'R-M-0000000-2';

  static String get bannerAdUnitId {
    if (kDebugMode || !_hasProductionBanner) return demoBannerAdUnitId;
    return productionBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode || !_hasProductionInterstitial) {
      return demoInterstitialAdUnitId;
    }
    return productionInterstitialAdUnitId;
  }
}
