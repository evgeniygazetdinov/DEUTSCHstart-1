import 'package:flutter/material.dart';

import 'yandex_sticky_banner.dart';

/// Оборачивает приложение: контент сверху, баннер Яндекса снизу.
class AppWithYandexBanner extends StatelessWidget {
  const AppWithYandexBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const YandexStickyBanner(),
      ],
    );
  }
}
