part of 'app_theme.dart';

abstract final class DarkAppColors {
  static Color get iconColor => const Color(0xFF7A747E); // Серые значки
  static Color get surface =>
      const Color(0xFF322F35); // Светло-серый фон карточки
  static Color get backgroundColor => const Color(0xFF242222); //фон экрана
}

abstract final class LightAppColors {
  static Color get cartColor1 => const Color(0xFF161616);
  static Color get cartColor2 => const Color(0xFFFDF8F6);
  static Color get cartColor3 => const Color(0xFFF3EFEF);
  static Color get cartColor4 => const Color(0xFF9B9794);
  static Color get cartColor5 => const Color(0xFFCACAC8);
  static Color get cartColor6 => const Color(0xFFE9B1B4);
}

abstract final class _AppColorScheme {
  static ColorScheme light() => ColorScheme.fromSeed(
        seedColor: LightAppColors.cartColor2,
        primary: LightAppColors.cartColor2,
        onPrimary: Colors.white,
        secondary: LightAppColors.cartColor6,
        onSecondary: LightAppColors.cartColor4,
        surface: LightAppColors.cartColor1,
        onSurface: LightAppColors.cartColor1,
        background: LightAppColors.cartColor3,
        onBackground: LightAppColors.cartColor2,
        inversePrimary: Colors.white,
      );
  static ColorScheme dark() => ColorScheme.fromSeed(
      seedColor: DarkAppColors.surface,
      primary: DarkAppColors.backgroundColor,
      onPrimary: Colors.white,
      secondary: DarkAppColors.iconColor,
      onSecondary: DarkAppColors.iconColor,
      surface: Colors.white,
      onSurface: Colors.white,
      background: DarkAppColors.surface,
      onBackground: DarkAppColors.surface,
      inversePrimary: DarkAppColors.backgroundColor);
}
