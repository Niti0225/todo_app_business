import 'package:flutter/material.dart';

class AppTheme {
  static const _seedBlue = Color(0xFF1565C0); // Einheitliches kräftiges Blau

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedBlue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'SF Pro',
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      cardColor: Colors.grey.shade100,
      dividerColor: Colors.grey.shade300,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedBlue,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'SF Pro',
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: Colors.grey.shade800,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
      ),
    );
  }
}
