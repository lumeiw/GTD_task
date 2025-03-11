part of 'app_theme.dart';

abstract final class LightAppColors {
  static Color get iconColor => const Color(0xFF7A747E);  // Серые значки
  static Color get surface => const Color(0xFF322F35); // Светло-серый фон карточки
  static Color get backgroundColor => const Color(0xFF242222); //фон экрана
  
  
  static Color get cartColor1 => const Color(0xFF161616);
  static Color get cartColor2 => const Color(0xFFFDF8F6);
  static Color get cartColor3 => const Color(0xFFF3EFEF);
  static Color get cartColor4 => const Color(0xFF9B9794);
  static Color get cartColor5 => const Color(0xFFCACAC8);
  static Color get cartColor6 => const Color(0xFFE9B1B4);



}

abstract final class _AppColorScheme {
  static ColorScheme main() => ColorScheme.fromSeed(
        seedColor: LightAppColors.cartColor2, // Цвет карточки
        primary: LightAppColors.surface, // Основной цвет оформления
        onPrimary: Colors.white, // Белый текст внутри карточки
        secondary: LightAppColors.cartColor6, // Цвет значков в карточке
        onSecondary: Colors.grey, // Белый текст на второстепенных элементах
        surface: LightAppColors.cartColor2, // Фон карточки
        onSurface:  LightAppColors.cartColor1, // Белый текст на карточке
        background: LightAppColors.backgroundColor, //Фон
        onBackground: Colors.white,
      );
}
