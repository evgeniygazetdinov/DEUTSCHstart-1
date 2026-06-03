import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';

enum AppLanguage { ru, en }

/// Управление языком UI: по умолчанию русский, сохранение выбора пользователя.
class AppLocaleController extends ChangeNotifier {
  AppLocaleController._(this._language, {required bool userChosen})
      : _userChosen = userChosen;

  static const _prefsKey = 'app_ui_language';

  AppLanguage _language;
  bool _userChosen;

  AppLanguage get language => _language;
  bool get userChosen => _userChosen;

  AppStrings get strings => AppStrings(_language);

  Locale get locale =>
      _language == AppLanguage.ru ? const Locale('ru') : const Locale('en');

  static Future<AppLocaleController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == 'ru') {
      return AppLocaleController._(AppLanguage.ru, userChosen: true);
    }
    if (saved == 'en') {
      return AppLocaleController._(AppLanguage.en, userChosen: true);
    }
    return AppLocaleController._(AppLanguage.ru, userChosen: false);
  }

  Future<void> toggleLanguage() async {
    await setLanguage(
      _language == AppLanguage.ru ? AppLanguage.en : AppLanguage.ru,
    );
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang && _userChosen) return;
    _language = lang;
    _userChosen = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      lang == AppLanguage.ru ? 'ru' : 'en',
    );
  }
}
