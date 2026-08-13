import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens from web `index.css` — see FLUTTER_APP_PLAN.md
class AppColors {
  static const primary = Color(0xFF1A237E);
  static const primaryDark = Color(0xFF0D1B6B);
  static const primarySoft = Color(0xFFE8EAF6);
  static const accent = Color(0xFF00A86B);
  static const accentHover = Color(0xFF008F5A);
  static const accentLight = Color(0xFF00C07A);
  static const textDark = Color(0xFF1E293B);
  static const textLight = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);
  static const bgLight = Color(0xFFF4F6FB);
  static const bgWhite = Color(0xFFFFFFFF);
  static const bgSoft = Color(0xFFEEF1F8);
  static const border = Color(0xFFE2E8F0);
}

class AppTheme {
  static TextTheme _textTheme(TextTheme base) {
    final manrope = GoogleFonts.manropeTextTheme(base);
    return manrope.copyWith(
      displayLarge: GoogleFonts.sourceSerif4(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.sourceSerif4(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        letterSpacing: -0.4,
      ),
      headlineMedium: GoogleFonts.sourceSerif4(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.65,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.bgWhite,
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.bgWhite,
        onSurface: AppColors.textDark,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.bgWhite.withValues(alpha: 0.92),
        foregroundColor: AppColors.primary,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sourceSerif4(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.bgWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: AppColors.bgWhite,
        indicatorColor: AppColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.textLight,
            size: 24,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    );
  }
}
