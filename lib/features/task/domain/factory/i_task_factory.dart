import '../entities/i_task_entity.dart';
import '../enums/folder_type_enum.dart';
import '../enums/task_duration_enum.dart';
import '../enums/task_flag_enum.dart';

abstract interface class TaskFactory {
  /// Создает новую задачу с указанными параметрами
  ITaskEntity createTask({
    required String title,
    required String body,
    required FolderType folder,
    DateTime? date,
    List<TaskFlag>? flags,
    TaskDuration duration = TaskDuration.undefined,
    bool isCompleted = false,
    String? projectId,
  });
  
  /// Создает копию существующей задачи с возможностью изменения отдельных полей
  ITaskEntity copyTask(
    ITaskEntity task, {
    String? title,
    String? body,
    FolderType? folder,
    DateTime? date,
    List<TaskFlag>? flags,
    TaskDuration? duration,
    DateTime? createdAt,
    bool? isCompleted,
    String? projectId,
  });
}