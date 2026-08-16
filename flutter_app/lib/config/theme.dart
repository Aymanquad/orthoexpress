import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens from web `index.css` — 8pt grid, clinic-calm surfaces.
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

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0x0F000000),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Calmer type scale: Manrope for UI + body, Source Serif 4 for page headlines only.
class AppTheme {
  static TextTheme _textTheme(TextTheme base) {
    final manrope = GoogleFonts.manropeTextTheme(base);
    return manrope.copyWith(
      displayLarge: GoogleFonts.sourceSerif4(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        letterSpacing: -0.35,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.sourceSerif4(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        letterSpacing: -0.3,
        height: 1.22,
      ),
      displaySmall: GoogleFonts.sourceSerif4(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.sourceSerif4(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        height: 1.35,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        height: 1.35,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        height: 1.35,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.bgWhite,
        letterSpacing: 0.2,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      ),
    );
  }

  static ThemeData light({bool highContrast = false, bool highlightLinks = false}) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: highContrast ? Colors.white : AppColors.bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: highContrast ? Colors.white : AppColors.bgWhite,
        onSurface: highContrast ? Colors.black : AppColors.textDark,
      ),
    );

    final borderColor = highContrast ? Colors.black : AppColors.border.withValues(alpha: 0.5);
    final linkColor = highContrast ? Colors.black : AppColors.accent;
    final linkStyle = GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: linkColor,
      decoration: highlightLinks ? TextDecoration.underline : TextDecoration.none,
      decorationColor: linkColor,
      decorationThickness: highlightLinks ? 2 : null,
    );

    final radius10 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56,
        backgroundColor: AppColors.bgWhite,
        foregroundColor: AppColors.primary,
        centerTitle: false,
        titleSpacing: 16,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          height: 1.25,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: highContrast ? Colors.white : AppColors.bgWhite,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: highContrast ? 2 : 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgWhite,
        labelStyle: GoogleFonts.manrope(fontSize: 14, color: AppColors.textLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.accent.withValues(alpha: 0.45);
            }
            if (states.contains(WidgetState.pressed)) return AppColors.accentHover;
            if (states.contains(WidgetState.hovered)) return AppColors.accentLight;
            return AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          minimumSize: WidgetStateProperty.all(const Size(44, 44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return 0;
            if (states.contains(WidgetState.hovered)) return 1;
            return 0;
          }),
          shadowColor: WidgetStateProperty.all(AppColors.accent.withValues(alpha: 0.35)),
          shape: WidgetStateProperty.all(radius10),
          textStyle: WidgetStateProperty.all(
            GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return AppColors.primary.withValues(alpha: 0.4);
            return AppColors.primary;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return AppColors.primarySoft.withValues(alpha: 0.45);
            if (states.contains(WidgetState.pressed)) return AppColors.primarySoft;
            return Colors.transparent;
          }),
          minimumSize: WidgetStateProperty.all(const Size(44, 44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          side: WidgetStateProperty.all(const BorderSide(color: AppColors.primary, width: 1.25)),
          shape: WidgetStateProperty.all(radius10),
          textStyle: WidgetStateProperty.all(
            GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: AppColors.bgWhite,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.manrope(
            fontSize: 10.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textMuted,
            height: 1.15,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.textMuted,
            size: selected ? 23 : 22,
          );
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primarySoft.withValues(alpha: 0.7);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primarySoft.withValues(alpha: 0.45);
          }
          return null;
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(linkColor),
          textStyle: WidgetStateProperty.all(linkStyle),
          minimumSize: WidgetStateProperty.all(const Size(36, 36)),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
          overlayColor: WidgetStateProperty.all(AppColors.primarySoft.withValues(alpha: 0.5)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.primary),
          minimumSize: WidgetStateProperty.all(const Size(36, 36)),
          iconSize: WidgetStateProperty.all(22),
          overlayColor: WidgetStateProperty.all(AppColors.primarySoft.withValues(alpha: 0.55)),
        ),
      ),
    );
  }
}
