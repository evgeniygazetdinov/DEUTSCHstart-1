import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../config/yandex_ads_config.dart';
import '../services/yandex_ads_service.dart';

/// Липкий баннер Яндекса внизу экрана (Android / iOS, не в debug).
class YandexStickyBanner extends StatefulWidget {
  const YandexStickyBanner({super.key});

  @override
  State<YandexStickyBanner> createState() => _YandexStickyBannerState();
}

class _YandexStickyBannerState extends State<YandexStickyBanner> {
  BannerAd? _banner;
  StreamSubscription<BannerAdLoadState>? _loadSub;
  var _visible = false;

  @override
  void initState() {
    super.initState();
    if (YandexAdsService.shouldShowAds) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setupBanner());
    }
  }

  Future<void> _setupBanner() async {
    if (!mounted || !YandexAdsService.shouldShowAds) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0) return;

    final adSize = BannerAdSize.sticky(width: width);
    final banner = BannerAd(adSize: adSize);

    _loadSub = banner.loadStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _visible = state is BannerAdLoadStateLoaded;
      });
    });

    setState(() => _banner = banner);
    await banner.load(
      AdRequest(adUnitId: YandexAdsConfig.bannerAdUnitId),
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
    if (!YandexAdsService.shouldShowAds || !_visible || _banner == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: AdWidget(bannerAd: _banner!),
    );
  }
}
