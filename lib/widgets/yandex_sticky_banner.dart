import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../config/yandex_ads_config.dart';
import '../services/yandex_ads_service.dart';

/// Липкий баннер Яндекса внизу экрана (Android / iOS).
class YandexStickyBanner extends StatefulWidget {
  const YandexStickyBanner({super.key});

  @override
  State<YandexStickyBanner> createState() => _YandexStickyBannerState();
}

class _YandexStickyBannerState extends State<YandexStickyBanner> {
  BannerAd? _banner;
  StreamSubscription<BannerAdLoadState>? _loadSub;
  int? _loadedWidth;
  String? _activeUnitId;
  var _loading = false;
  var _productionRetriesLeft = 0;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    } else {
      // В release — видно в adb logcat.
      // ignore: avoid_print
      print(message);
    }
  }

  @override
  void initState() {
    super.initState();
    _productionRetriesLeft = YandexAdsConfig.productionLoadRetries;
  }

  Future<void> _loadBanner({
    required int width,
    required String unitId,
    bool isDemoFallback = false,
  }) async {
    if (!mounted || !YandexAdsService.shouldShowAds || _loading) return;
    if (_banner != null && _loadedWidth == width && _activeUnitId == unitId) {
      return;
    }

    _loading = true;
    await _loadSub?.cancel();
    await _banner?.destroy();

    final adSize = BannerAdSize.sticky(width: width);
    try {
      await adSize.getCalculatedBannerAdSize();
    } on Object catch (e) {
      _log('Yandex banner size calc failed: $e');
    }

    final banner = BannerAd(adSize: adSize);
    final completer = Completer<BannerAdLoadState>();

    _loadSub = banner.loadStateStream.listen((state) {
      if (!mounted) return;
      if (state is BannerAdLoadStateLoaded) {
        _log('Yandex banner loaded [$unitId] ${state.width}x${state.height}');
        if (!completer.isCompleted) completer.complete(state);
      } else if (state is BannerAdLoadStateError) {
        _log(
          'Yandex banner error [$unitId] ${state.error.code}: '
          '${state.error.description}',
        );
        if (!completer.isCompleted) completer.complete(state);
      }
      setState(() {});
    });

    setState(() {
      _banner = banner;
      _loadedWidth = width;
      _activeUnitId = unitId;
    });

    _log('Yandex banner loading [$unitId] width=$width demo=$isDemoFallback');

    try {
      await banner.load(AdRequest(adUnitId: unitId));
      final result = await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => BannerAdLoadStateError(
          error: AdRequestError(0, 'timeout', unitId),
        ),
      );

      if (!mounted) return;

      if (result is BannerAdLoadStateError &&
          !isDemoFallback &&
          unitId != YandexAdsConfig.demoBannerAdUnitId) {
        if (_productionRetriesLeft > 0) {
          _productionRetriesLeft--;
          _log('Yandex banner retry, left=$_productionRetriesLeft');
          _loadedWidth = null;
          await Future<void>.delayed(const Duration(seconds: 2));
          if (mounted) {
            await _loadBanner(width: width, unitId: unitId);
          }
          return;
        }
        if (YandexAdsConfig.fallbackToDemoOnError) {
          _log('Yandex banner → demo fallback');
          _loadedWidth = null;
          await _loadBanner(
            width: width,
            unitId: YandexAdsConfig.demoBannerAdUnitId,
            isDemoFallback: true,
          );
        }
      }
    } on Object catch (e) {
      _log('Yandex banner exception [$unitId]: $e');
    } finally {
      _loading = false;
    }
  }

  Future<void> _startLoad(int width) async {
    _productionRetriesLeft = YandexAdsConfig.productionLoadRetries;
    await _loadBanner(
      width: width,
      unitId: YandexAdsConfig.primaryBannerAdUnitId,
    );
  }

  @override
  void dispose() {
    _loadSub?.cancel();
    _banner?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!YandexAdsService.shouldShowAds) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.truncate();
        if (width > 0 && _banner == null && !_loading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startLoad(width);
          });
        } else if (width > 0 &&
            _loadedWidth != null &&
            _loadedWidth != width &&
            !_loading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startLoad(width);
          });
        }

        final banner = _banner;
        if (banner == null) {
          return const SizedBox.shrink();
        }

        return ColoredBox(
          color: const Color(0xFFF2F2F7),
          child: SafeArea(
            top: false,
            child: AdWidget(bannerAd: banner),
          ),
        );
      },
    );
  }
}
