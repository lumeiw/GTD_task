import 'package:shared_preferences/shared_preferences.dart';

/// Класс для работы с локальным хранилищем на основе SharedPreferences
class LocalStorage {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Инициализация хранилища
  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Сохранение строки
  Future<bool> setString(String key, String value) async {
    _checkInitialization();
    return await _prefs.setString(key, value);
  }

  /// Получение строки
  String? getString(String key) {
    _checkInitialization();
    return _prefs.getString(key);
  }

  /// Сохранение целого числа
  Future<bool> setInt(String key, int value) async {
    _checkInitialization();
    return await _prefs.setInt(key, value);
  }

  /// Получение целого числа
  int? getInt(String key) {
    _checkInitialization();
    return _prefs.getInt(key);
  }

  /// Сохранение логического значения
  Future<bool> setBool(String key, bool value) async {
    _checkInitialization();
    return await _prefs.setBool(key, value);
  }

  /// Получение логического значения
  bool? getBool(String key) {
    _checkInitialization();
    return _prefs.getBool(key);
  }

  /// Сохранение списка строк
  Future<bool> setStringList(String key, List<String> value) async {
    _checkInitialization();
    return await _prefs.setStringList(key, value);
  }

  /// Получение списка строк
  List<String>? getStringList(String key) {
    _checkInitialization();
    return _prefs.getStringList(key);
  }

  /// Получение ключей с определенным префиксом
  Set<String> getKeysByPrefix(String prefix) {
    _checkInitialization();
    return _prefs.getKeys().where((key) => key.startsWith(prefix)).toSet();
  }

  /// Удаление значения по ключу
  Future<bool> remove(String key) async {
    _checkInitialization();
    return await _prefs.remove(key);
  }

  /// Очистка всего хранилища
  Future<bool> clear() async {
    _checkInitialization();
    return await _prefs.clear();
  }

  /// Проверка инициализации
  void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception('LocalStorage не инициализирован. Вызовите init() перед использованием.');
    }
  }
}