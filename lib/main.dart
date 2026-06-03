import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_locale.dart';
import 'l10n/app_locale_scope.dart';
import 'screens/home_screen.dart';
import 'theme/apple_theme.dart';
import 'services/yandex_ads_service.dart';
import 'widgets/app_with_yandex_banner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await YandexAdsService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const _appSupportedLocales = [
  Locale('en'),
  Locale('ru'),
];

const _appLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class _MyAppState extends State<MyApp> {
  AppLocaleController? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final ctrl = await AppLocaleController.load();
    if (!mounted) return;
    setState(() => _locale = ctrl);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _locale;
    if (ctrl == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppleTheme.light(),
        localizationsDelegates: _appLocalizationsDelegates,
        supportedLocales: _appSupportedLocales,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return AppLocaleScope(
      controller: ctrl,
      child: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          return MaterialApp(
            title: ctrl.strings.appTitle,
            debugShowCheckedModeBanner: false,
            locale: ctrl.locale,
            localizationsDelegates: _appLocalizationsDelegates,
            supportedLocales: _appSupportedLocales,
            theme: AppleTheme.light(),
            builder: (context, child) {
              if (child == null) {
                return const SizedBox.shrink();
              }
              return AppWithYandexBanner(child: child);
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
