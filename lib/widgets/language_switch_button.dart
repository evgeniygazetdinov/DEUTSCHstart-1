import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_locale_scope.dart';
import '../theme/apple_theme.dart';

/// Кнопка RU ↔ EN в стиле iOS.
class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.localeController;
    final isRu = ctrl.language == AppLanguage.ru;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: ctrl.toggleLanguage,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              isRu ? 'RU' : 'EN',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.08,
                color: AppleTheme.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
