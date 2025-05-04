//* TaskLocalSource - класс для работы с локальным хранилищем:
//* Методы CRUD для работы с SharedPreferences
//* Преобразование данных в JSON и обратно

import 'package:gtd_task/core/storage/local_storage.dart';
import 'package:gtd_task/features/task/data/models/task_model.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TaskLocalSource {
  final LocalStorage _storage;
  static const String _keyPrefix = 'task_';

  TaskLocalSource(this._storage);

  /// Получение всех задач
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final taskKeys = _storage.getKeysByPrefix(_keyPrefix);
      final tasksMap = <String, TaskModel>{};
      for (final key in taskKeys) {
        final jsonString = _storage.getString(key);
        if (jsonString != null) {
          final task = TaskModel.fromJsonString(jsonString);
          tasksMap[task.id] = task;
        }
      }
      final tasks = tasksMap.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    } catch (e) {
      throw Exception('Ошибка при получении задач: $e');
    }
  }

  /// Получение задачи по ID
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final key = _getKeyForId(id);
      final jsonString = _storage.getString(key);

      if (jsonString == null) {
        return null;
      }

      return TaskModel.fromJsonString(jsonString);
    } catch (e) {
      throw Exception('Ошибка при получении задачи: $e');
    }
  }

  /// Получение задач из определенной папки
  Future<List<TaskModel>> getTasksByFolder(FolderType folder) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.folder == folder).toList();
    } catch (e) {
      throw Exception('Ошибка при получении задач из папки: $e');
    }
  }

  /// Создание новой задачи
  Future<void> createTask(TaskModel task) async {
    try {
      await saveTask(task);
    } catch (e) {
      throw Exception('Ошибка при создании задачи: $e');
    }
  }

  /// Обновление существующей задачи
  Future<void> updateTask(TaskModel task) async {
    try {
      await saveTask(task);
    } catch (e) {
      throw Exception('Ошибка при обновлении задачи: $e');
    }
  }

  /// Сохранение задачи (создание или обновление)
  Future<void> saveTask(TaskModel task) async {
    try {
      final key = _getKeyForId(task.id);
      await _storage.setString(key, task.toJsonString());
    } catch (e) {
      throw Exception('Ошибка при сохранении задачи: $e');
    }
  }

  /// Удаление задачи
  Future<void> deleteTask(String id) async {
    try {
      final key = _getKeyForId(id);
      await _storage.remove(key);
    } catch (e) {
      throw Exception('Ошибка при удалении задачи: $e');
    }
  }

  /// Поиск задач
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final allTasks = await getAllTasks();
      final lowercaseQuery = query.toLowerCase();

      return allTasks.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
            task.body.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Ошибка при поиске задач: $e');
    }
  }

  /// Формирование ключа для задачи
  String _getKeyForId(String id) {
    return '$_keyPrefix$id';
  }

  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    try {
      final allTasks = await getAllTasks(); // Получаем все задачи
      return allTasks.where((task) => task.projectId == projectId).toList();
    } catch (e) {
      throw Exception('Ошибка при получении задач проекта: $e');
    }
  }
}
