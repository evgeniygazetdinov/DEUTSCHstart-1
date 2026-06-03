import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_locale_scope.dart';

/// Кнопка RU ↔ EN в AppBar; по умолчанию русский.
class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.localeController;
    final s = context.s;
    final isRu = ctrl.language == AppLanguage.ru;
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      tooltip: isRu ? s.languageSwitchToEn : s.languageSwitchToRu,
      onPressed: ctrl.toggleLanguage,
      icon: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.55),
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            isRu ? 'RU' : 'EN',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
