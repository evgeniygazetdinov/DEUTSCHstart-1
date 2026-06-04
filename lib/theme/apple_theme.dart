import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Палитра и тема в духе iOS (светлая).
abstract final class AppleTheme {
  static const Color blue = Color(0xFF007AFF);
  static const Color groupedBackground = Color(0xFFF2F2F7);
  static const Color secondaryGrouped = Color(0xFFFFFFFF);
  static const Color separator = Color(0xFFC6C6C8);
  /// Основной текст на светлом фоне (iOS label).
  static const Color primaryLabel = Color(0xFF1C1C1E);
  static const Color secondaryLabel = Color(0xFF8E8E93);
  static const Color tertiaryLabel = Color(0xFFAEAEB2);
  static const Color green = Color(0xFF34C759);
  static const Color red = Color(0xFFFF3B30);

  static const double cornerRadius = 12;
  static const double groupedMargin = 16;

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: blue,
      onPrimary: Colors.white,
      secondary: Color(0xFF5856D6),
      surface: secondaryGrouped,
      onSurface: primaryLabel,
      onSurfaceVariant: secondaryLabel,
      outline: separator,
      outlineVariant: Color(0xFFE5E5EA),
      surfaceContainerHighest: Color(0xFFE5E5EA),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: groupedBackground,
      dividerColor: separator,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: groupedBackground,
        foregroundColor: Color(0xFF000000),
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: Color(0xFF000000),
        ),
        iconTheme: IconThemeData(color: blue, size: 22),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: blue,
        unselectedLabelColor: secondaryLabel,
        indicatorColor: blue,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.08,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: secondaryGrouped,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: blue,
        textColor: Color(0xFF000000),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: separator,
        space: 0,
        thickness: 0.5,
        indent: 56,
      ),
      textTheme: _textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: blue,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE5E5EA),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: blue),
      iconTheme: const IconThemeData(color: blue),
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: secondaryGrouped,
        collapsedBackgroundColor: secondaryGrouped,
        iconColor: secondaryLabel,
        collapsedIconColor: secondaryLabel,
        textColor: Color(0xFF000000),
        collapsedTextColor: Color(0xFF000000),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1C1C1E),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: secondaryGrouped.withValues(alpha: 0.94),
        indicatorColor: const Color(0xFFE5E5EA),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.37,
      height: 1.1,
      color: primaryLabel,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.35,
      color: primaryLabel,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.2,
      color: primaryLabel,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.38,
      color: primaryLabel,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
      color: primaryLabel,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.24,
      color: primaryLabel,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4,
      height: 1.35,
      color: primaryLabel,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.24,
      height: 1.35,
      color: primaryLabel,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.08,
      height: 1.3,
    ),
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.08,
      color: secondaryLabel,
    ),
  );
}
