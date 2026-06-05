import 'package:yandex_mobileads/mobile_ads.dart';

import '../config/yandex_ads_config.dart';
import 'yandex_ads_service.dart';

/// Полноэкранная реклама (после Mix и т.п.).
final class YandexInterstitialService {
  YandexInterstitialService._();

  static final YandexInterstitialService instance = YandexInterstitialService._();

  final InterstitialAdLoader _loader = InterstitialAdLoader();
  InterstitialAd? _ad;
  bool _loading = false;

  Future<void> preload() async {
    if (!YandexAdsService.shouldShowAds || _ad != null || _loading) return;
    _loading = true;
    try {
      _ad = await _loader.loadAd(
        adRequest: AdRequest(adUnitId: YandexAdsConfig.interstitialAdUnitId),
      );
    } on AdRequestError {
      _ad = null;
    } finally {
      _loading = false;
    }
  }

  /// Показать, если объявление уже загружено (например после Mix).
  Future<void> showIfReady() async {
    if (!YandexAdsService.shouldShowAds) return;
    if (_ad == null) {
      await preload();
    }
    final ad = _ad;
    if (ad == null) return;

    _ad = null;
    try {
      await ad.setAdEventListener(
        eventListener: InterstitialAdEventListener(),
      );
      await ad.show();
      await ad.waitForDismiss();
    } on Object {
      // ignore: показ не обязателен для работы приложения
    }
    preload();
  }
}
