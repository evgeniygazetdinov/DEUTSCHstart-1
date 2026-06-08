import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'yandex_interstitial_service.dart';

/// Инициализация Yandex Mobile Ads (только Android / iOS).
abstract final class YandexAdsService {
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Реклама на телефоне/планшете; на Linux/desktop и Web не показываем.
  static bool get shouldShowAds => isSupported;

  static var _initialized = false;

  static Future<void> initialize() async {
    if (!isSupported || _initialized) return;
    // Красная плашка SDK при ошибке — помогает на устройстве (adb logcat тоже).
    await YandexAds.setDebugErrorIndicator(true);
    await YandexAds.initialize();
    _initialized = true;
    // Не блокируем старт приложения — баннер важнее.
    unawaited(YandexInterstitialService.instance.preload());
  }
}
