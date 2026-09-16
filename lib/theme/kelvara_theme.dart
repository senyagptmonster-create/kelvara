import 'package:flutter/material.dart';

class KelvaraTheme {
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFE2E8F0);
  static const accent = Color(0xFF2563EB); // Optical Blue
  static const accentLight = Color(0xFF60A5FA);
  static const ink = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: ink,
        iconTheme: IconThemeData(color: ink),
      ),
    );
  }
}
