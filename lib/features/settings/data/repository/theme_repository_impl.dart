import 'package:gtd_task/core/storage/local_storage.dart';
import 'package:gtd_task/features/settings/domain/repository/theme_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  final LocalStorage _localstorage;
  static const String _themeKey = 'isDarkTheme';

  ThemeRepositoryImpl({required LocalStorage localstorage})
      : _localstorage = localstorage;

  @override
  Future<void> saveTheme(bool isDark) async {
    try {
      await _localstorage.setBool(_themeKey, isDark);
    } catch (e) {
      throw Exception('Ошибка сохранения темы: $e');
    }
  }

  @override
  Future<bool> isDarkTheme() async {
    try {
      return _localstorage.getBool(_themeKey) ?? false;
    } catch (e) {
      throw Exception('Ошибка получения темы: $e');
    }
  }
}
