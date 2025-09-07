import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Inspired by Calm/BetterHelp/Headspace
  static const Color primaryBlue = Color(0xFF6B73FF);
  static const Color primaryGreen = Color(0xFF00D4AA);
  static const Color softBlue = Color(0xFFE8F4FD);
  static const Color softGreen = Color(0xFFE8FDF9);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C7B7F);
  static const Color darkGray = Color(0xFF2D3748);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF51CF66);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [softBlue, softGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkGray,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: darkGray,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: darkGray,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: mediumGray,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: mediumGray,
    height: 1.4,
  );

  // Button Styles
  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: white,
      backgroundColor: primaryBlue,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryBlue,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      side: const BorderSide(color: primaryBlue, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Input Decoration
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: lightGray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(
      color: mediumGray,
      fontSize: 14,
      fontFamily: 'Inter',
    ),
    labelStyle: const TextStyle(
      color: mediumGray,
      fontSize: 14,
      fontFamily: 'Inter',
    ),
  );

  // App Bar Theme
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: white,
    foregroundColor: darkGray,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: darkGray,
    ),
    iconTheme: IconThemeData(color: darkGray),
  );

  // Card Theme
  static final CardTheme cardTheme = CardTheme(
    color: white,
    elevation: 0,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.all(8),
  );

  // Main Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: primaryGreen,
        surface: white,
        background: white,
        error: error,
      ),
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: appBarTheme,
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      dividerColor: lightGray,
      textTheme: const TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingMedium,
        displaySmall: headingSmall,
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        titleLarge: headingMedium,
        titleMedium: headingSmall,
        titleSmall: bodyLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: bodyMedium,
        labelMedium: bodySmall,
        labelSmall: caption,
      ),
    );
  }
}