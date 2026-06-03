import 'package:flutter/foundation.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

/// Инициализация Yandex Mobile Ads (только Android / iOS).
abstract final class YandexAdsService {
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Реклама только в release/profile, не в debug.
  static bool get shouldShowAds => isSupported && !kDebugMode;

  static Future<void> initialize() async {
    if (!isSupported) return;
    await YandexAds.setDebugErrorIndicator(false);
    await YandexAds.initialize();
  }
}
