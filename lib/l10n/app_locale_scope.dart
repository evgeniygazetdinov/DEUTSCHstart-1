import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'app_strings.dart';

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLocaleController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found');
    return scope!.notifier!;
  }

  static AppStrings stringsOf(BuildContext context) => of(context).strings;
}

extension AppStringsContext on BuildContext {
  AppStrings get s => AppLocaleScope.stringsOf(this);
  AppLocaleController get localeController => AppLocaleScope.of(this);
}
