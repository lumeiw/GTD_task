part of 'app_theme.dart';

abstract final class LightAppColors {
  static Color get iconColor => const Color(0xFF79747E); // Серые значки
  static Color get surface =>
      const Color(0xFF322F35); // Светло-серый фон карточки
  static Color get backgroundColor => const Color(0xFF242222); //фон экрана
}

abstract final class _AppColorScheme {
  static ColorScheme main() => ColorScheme.fromSeed(
        seedColor: LightAppColors.surface, // Цвет карточки
        primary: LightAppColors.surface, // Основной цвет оформления
        onPrimary: Colors.white, // Белый текст внутри карточки
        secondary: LightAppColors.iconColor, // Цвет значков в карточке
        onSecondary: Colors.white, // Белый текст на второстепенных элементах
        surface: LightAppColors.surface, // Фон карточки
        onSurface: Colors.white, // Белый текст на карточке
        background: LightAppColors.backgroundColor, //Фон
        onBackground: Colors.white,
      );
}
