abstract interface class ThemeRepository {
  Future<bool> isDarkTheme();
  Future<void> saveTheme(bool isDark);
}
