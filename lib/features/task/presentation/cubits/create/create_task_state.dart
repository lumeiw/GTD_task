import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';

abstract class CreateTaskState {
  get task => null;
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskEditing extends CreateTaskState {
  final int id; // Добавлено поле id
  final String title;
  final String body;
  final FolderType folder;
  final List<TaskFlag> flags;
  final TaskDuration duration;
  final DateTime? date;
  final String? projectId;
  final bool isCompleted;
  final int? notificationIdEvening;
  final int? notificationIdMorning;

  CreateTaskEditing({
    int? id, // Инициализация id
    this.title = '',
    this.body = '',
    this.folder = FolderType.inbox,
    this.flags = const [],
    this.duration = TaskDuration.undefined,
    this.date,
    this.projectId,
    this.isCompleted = false,
    this.notificationIdEvening,
    this.notificationIdMorning,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  CreateTaskEditing copyWith({
    int? id,
    String? title,
    String? body,
    FolderType? folder,
    List<TaskFlag>? flags,
    TaskDuration? duration,
    DateTime? date,
    String? projectId,
    bool? isCompleted,
    int? notificationIdEvening,
    int? notificationIdMorning,
  }) {
    return CreateTaskEditing(
      id: id ?? this.id, // Обновление id
      title: title ?? this.title,
      body: body ?? this.body,
      folder: folder ?? this.folder,
      flags: flags ?? this.flags,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      projectId: projectId ?? this.projectId,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationIdEvening:
          notificationIdEvening ?? this.notificationIdEvening,
      notificationIdMorning:
          notificationIdMorning ?? this.notificationIdMorning,
    );
  }
}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final ITaskEntity? task;

  CreateTaskSuccess([this.task]);
}

class CreateTaskError extends CreateTaskState {
  final String message;
  CreateTaskError(this.message);
}
