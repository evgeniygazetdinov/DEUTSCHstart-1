import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../config/yandex_ads_config.dart';
import '../services/yandex_ads_service.dart';

/// Липкий баннер Яндекса внизу экрана (Android / iOS).
///
/// [AdWidget] должен быть в дереве до/во время [BannerAd.load] — иначе
/// platform view не создаётся и реклама никогда не загрузится.
class YandexStickyBanner extends StatefulWidget {
  const YandexStickyBanner({super.key});

  @override
  State<YandexStickyBanner> createState() => _YandexStickyBannerState();
}

class _YandexStickyBannerState extends State<YandexStickyBanner> {
  BannerAd? _banner;
  StreamSubscription<BannerAdLoadState>? _loadSub;
  int? _loadedWidth;
  var _loading = false;

  @override
  void initState() {
    super.initState();
    if (YandexAdsService.shouldShowAds) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadBannerIfNeeded());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (YandexAdsService.shouldShowAds) {
      _loadBannerIfNeeded();
    }
  }

  Future<void> _loadBannerIfNeeded() async {
    if (!mounted || !YandexAdsService.shouldShowAds || _loading) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0) return;
    if (_banner != null && _loadedWidth == width) return;

    _loading = true;
    await _loadSub?.cancel();
    await _banner?.destroy();

    final adSize = BannerAdSize.sticky(width: width);
    final banner = BannerAd(adSize: adSize);

    _loadSub = banner.loadStateStream.listen((state) {
      if (!mounted) return;
      if (state is BannerAdLoadStateError && kDebugMode) {
        debugPrint(
          'Yandex banner error ${state.error.code}: ${state.error.description}',
        );
      }
      setState(() {});
    });

    setState(() {
      _banner = banner;
      _loadedWidth = width;
    });

    try {
      await banner.load(
        AdRequest(adUnitId: YandexAdsConfig.bannerAdUnitId),
      );
    } finally {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _loadSub?.cancel();
    _banner?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (!YandexAdsService.shouldShowAds || banner == null) {
      return const SizedBox.shrink();
    }

    return ColoredBox(
      color: const Color(0xFFF2F2F7),
      child: SafeArea(
        top: false,
        child: AdWidget(bannerAd: banner),
      ),
    );
  }
}
