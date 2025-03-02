import 'package:flutter/material.dart';

part 'color_scheme.dart';

abstract final class AppFont {
  static const String rb = 'Roboto';
}

abstract final class AppTheme {
  static ThemeData get theme => _createThemeData(_AppColorScheme.main());

  static ThemeData _createThemeData(ColorScheme colorScheme) {
    final theme = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        bodyLarge: TextStyle(
          fontSize: 16, fontFamily: AppFont.rb, color: colorScheme.onPrimary),
      ),
      scaffoldBackgroundColor: LightAppColors.backgroundColor,
      cardTheme: CardTheme(
        color: colorScheme.surface, // Цвет карточки
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Скругление углов
        ),
        elevation: 5, // Тень
        shadowColor: colorScheme.primary.withOpacity(0.2),
      ),
      iconTheme: IconThemeData(
        color: colorScheme.secondary, // Цвет значков
        size: 27,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightAppColors.surface,
          foregroundColor: LightAppColors.iconColor,
          textStyle: const TextStyle(
            fontFamily: AppFont.rb,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
