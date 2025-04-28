import 'package:gtd_task/features/task/data/models/task_model.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TaskFactory)
class TaskFactoryImpl implements TaskFactory {
  @override
  ITaskEntity createTask({
    required String title,
    required String body,
    required FolderType folder,
    DateTime? date,
    List<TaskFlag>? flags,
    bool isCompleted = false,
    TaskDuration duration = TaskDuration.undefined,
    String? projectId,
  }) {
    return TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      folder: folder,
      date: date,
      flags: flags ?? [TaskFlag.none],
      createdAt: DateTime.now(),
      isCompleted: isCompleted,
      duration: duration,
      projectId: projectId,
    );
  }
  
  @override
  ITaskEntity copyTask(
    ITaskEntity task, {
    String? title,
    String? body,
    FolderType? folder,
    DateTime? date,
    List<TaskFlag>? flags,
    DateTime? createdAt,
    bool? isCompleted,
    TaskDuration? duration,
    String? projectId,
  }) {
    // Используем существующий метод copyWith, если task - это TaskModel
    if (task is TaskModel) {
      return task.copyWith(
        title: title,
        body: body,
        folder: folder,
        date: date,
        flags: flags,
        createdAt: createdAt,
        isCompleted: isCompleted,
        duration: duration,
        projectId: projectId,
      );
    }
    
    // Если это не TaskModel, создаем новый объект
    return TaskModel(
      id: task.id,
      title: title ?? task.title,
      body: body ?? task.body,
      folder: folder ?? task.folder,
      date: date ?? task.date,
      flags: flags ?? task.flags,
      createdAt: createdAt ?? task.createdAt,
      isCompleted: isCompleted ?? task.isCompleted,
      duration: duration ?? task.duration,
      projectId: projectId ?? task.projectId,
    );
  }
}