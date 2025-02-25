import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';

abstract interface class ITaskRepository {
  Future<List<ITaskEntity>> getAllTasks(); // Получает список всех задач.
  Future<ITaskEntity?> getTaskById(String id); // Получает задачу по её уникальному идентификатору.
  Future<List<ITaskEntity>> getTasksByFolder(FolderType folder); // Получает список задач, относящихся к указанной папке.
  Future<void> createTask(ITaskEntity task); // Создаёт новую задачу.
  Future<void> updateTask(ITaskEntity task); // Обновляет существующую задачу.
  Future<void> deleteTask(String id); // Удаляет задачу по её `id`
  Future<List<ITaskEntity>> searchTasks(String query); // Выполняет поиск задач по заданному запросу `query`.
  Future<List<ITaskEntity>> getTasksByProject(String projectId); // Получение задач по проекту
}
