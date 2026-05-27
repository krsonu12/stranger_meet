import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Centralized theme definitions for light and dark modes.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: _textTheme(AppColors.grey900),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.grey900),
          titleTextStyle: AppTextStyles.heading3,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _textTheme(AppColors.white),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(dark: true),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
      );

  static TextTheme _textTheme(Color baseColor) => TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(color: baseColor),
        displayMedium: AppTextStyles.heading2.copyWith(color: baseColor),
        displaySmall: AppTextStyles.heading3.copyWith(color: baseColor),
        bodyLarge: AppTextStyles.body1.copyWith(color: baseColor),
        bodyMedium: AppTextStyles.body2,
        labelSmall: AppTextStyles.caption,
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.grey300),
          textStyle: AppTextStyles.button,
        ),
      );

  static InputDecorationTheme _inputDecorationTheme({bool dark = false}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.surfaceDark : AppColors.grey100,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
}
