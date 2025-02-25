//* TaskRepositoryImpl - реализация репозитория:
//* Имплементирует ITaskRepository
//* Использует TaskLocalSource для работы с данными
//* Обрабатывает ошибки

import 'package:gtd_task/features/task/data/datasources/local/task_local_source.dart';
import 'package:gtd_task/features/task/data/models/task_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import '../../domain/enums/folder_type_enum.dart';

@LazySingleton(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final TaskLocalSource _localSource;

  TaskRepositoryImpl({required TaskLocalSource localSource}) 
      : _localSource = localSource;

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
      return await _localSource.getTaskById(id);
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
      final taskModel = _ensureTaskModel(task);
      await _localSource.createTask(taskModel);
    } catch (e) {
      throw Exception('Ошибка создания задачи: $e');
    }
  }

  @override
  Future<void> updateTask(ITaskEntity task) async {
    try {
      final taskModel = _ensureTaskModel(task);
      await _localSource.updateTask(taskModel);
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

  TaskModel _ensureTaskModel(ITaskEntity task) {
    if (task is TaskModel) {
      return task;
    }
    
    return TaskModel(
      id: task.id,
      title: task.title,
      body: task.body,
      folder: task.folder,
      date: task.date,
      flags: task.flags,
      createdAt: task.createdAt,
      isCompleted: task.isCompleted,
    );
  }
}