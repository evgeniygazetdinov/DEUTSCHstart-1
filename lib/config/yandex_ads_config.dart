import 'package:flutter/foundation.dart';

import 'yandex_ads_secrets.dart';

/// Публичные настройки Yandex Mobile Ads (без секретов — можно в Git).
abstract final class YandexAdsConfig {
  static const demoBannerAdUnitId = 'demo-banner-yandex';
  static const demoInterstitialAdUnitId = 'demo-interstitial-yandex';

  static const _bannerFromEnv = String.fromEnvironment('YANDEX_BANNER_AD_UNIT_ID');
  static const _interstitialFromEnv =
      String.fromEnvironment('YANDEX_INTERSTITIAL_AD_UNIT_ID');

  /// `flutter run` — демо-блок (удобно при разработке).
  static const useDemoBannerInDebug = true;

  /// Если боевой блок не ответил — показать демо (иначе баннер пустой).
  static const fallbackToDemoOnError = true;

  /// Сколько раз повторить загрузку боевого блока перед fallback.
  static const productionLoadRetries = 2;

  static String get productionBannerAdUnitId =>
      _bannerFromEnv.isNotEmpty ? _bannerFromEnv : YandexAdsSecrets.bannerAdUnitId;

  static String get productionInterstitialAdUnitId =>
      _interstitialFromEnv.isNotEmpty
          ? _interstitialFromEnv
          : YandexAdsSecrets.interstitialAdUnitId;

  static bool get _hasProductionBanner => productionBannerAdUnitId.trim().isNotEmpty;

  static bool get _hasProductionInterstitial =>
      productionInterstitialAdUnitId.trim().isNotEmpty;

  /// Первая попытка: боевой в release, демо в debug.
  static String get primaryBannerAdUnitId {
    if (kDebugMode && useDemoBannerInDebug) return demoBannerAdUnitId;
    if (!_hasProductionBanner) return demoBannerAdUnitId;
    return productionBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode || !_hasProductionInterstitial) {
      return demoInterstitialAdUnitId;
    }
    return productionInterstitialAdUnitId;
  }
}
