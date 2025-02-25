//TODO: Реализация ITaskRepository

//* TaskRepositoryImpl - реализация репозитория:
//* Имплементирует ITaskRepository
//* Использует TaskLocalSource для работы с данными
//* Обрабатывает ошибки

import '../../domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import '../../domain/enums/folder_type_enum.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final TaskLocalSource _localSource;

  TaskRepositoryImpl({required this._localSource});

  @override
  Future<List<ITaskEntity>> getAllTasks() async {
    try {
      return await _localSource.getAllTasks();
    } catch (e) {
      throw Exception('Ошибка загрузки задач: $e');
    }
  }

  @override
  Future<ITaskEntity?> getTaskById(String id) async {
    try {
      return await _localSource.getTaskbyId(id);
    } catch (e) {
      throw Exception('Ошибка загрузки задач: $e');
    }
  }

  @override
  Future<List<ITaskEntity>> getTasksByFolder(FolderType folder) async {
    try {
      return await _localSource.getTasksByFolder(folder);
    } catch (e) {
      throw Exception('Ошибка загрузки задач из папки: $e');
    }
  }

  @override
  Future<void> createTask(ITaskEntity task) async {
    try {
      await _localSource.createTask(task);
    } catch (e) {
      throw Exception('Ошибка создания задачи: $e');
    }
  }

  @override
  Future<void> updateTask(ITaskEntity task) async {
    try {
      await _localSource.updateTask(task);
    } catch (e) {
      throw Exception('Ошибка обновления задачи: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _localSource.deleteTask(id);
    } catch (e) {
      throw Exception('Ошибка удаления задачи: $e');
    }
  }

  @override
  Future<List<ITaskEntity>> searchTasks(String query) async {
    try {
      return await _localSource.searchTasks(query);
    } catch (e) {
      throw Exception('Ошибка поиска задач: $e');
    }
  }
}