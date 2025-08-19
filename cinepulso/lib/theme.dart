import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GSFilmsColors {
  // Primary GSFilms Colors - Dark theme with neon gold accents
  static const neonGold = Color(0xFFFFD700);
  static const darkGold = Color(0xFFB8860B);
  static const black = Color(0xFF000000);
  static const richBlack = Color(0xFF0A0A0A);
  static const charcoal = Color(0xFF1A1A1A);
  static const darkGray = Color(0xFF2A2A2A);
  static const mediumGray = Color(0xFF404040);
  static const lightGray = Color(0xFF6A6A6A);
  static const white = Color(0xFFFFFFFF);
  static const error = Color(0xFFFF4444);
  static const success = Color(0xFF00FF88);
}


class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: GSFilmsColors.neonGold,
    onPrimary: GSFilmsColors.black,
    primaryContainer: GSFilmsColors.darkGold,
    onPrimaryContainer: GSFilmsColors.white,
    secondary: GSFilmsColors.mediumGray,
    onSecondary: GSFilmsColors.white,
    tertiary: GSFilmsColors.lightGray,
    onTertiary: GSFilmsColors.white,
    error: GSFilmsColors.error,
    onError: GSFilmsColors.white,
    surface: GSFilmsColors.charcoal,
    onSurface: GSFilmsColors.white,
    background: GSFilmsColors.black,
    onBackground: GSFilmsColors.white,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: GSFilmsColors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: GSFilmsColors.richBlack,
    foregroundColor: GSFilmsColors.white,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: GSFilmsColors.neonGold,
    onPrimary: GSFilmsColors.black,
    primaryContainer: GSFilmsColors.darkGold,
    onPrimaryContainer: GSFilmsColors.white,
    secondary: GSFilmsColors.mediumGray,
    onSecondary: GSFilmsColors.white,
    tertiary: GSFilmsColors.lightGray,
    onTertiary: GSFilmsColors.white,
    error: GSFilmsColors.error,
    onError: GSFilmsColors.white,
    surface: GSFilmsColors.charcoal,
    onSurface: GSFilmsColors.white,
    background: GSFilmsColors.black,
    onBackground: GSFilmsColors.white,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: GSFilmsColors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: GSFilmsColors.richBlack,
    foregroundColor: GSFilmsColors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: GSFilmsColors.neonGold,
      foregroundColor: GSFilmsColors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
);
