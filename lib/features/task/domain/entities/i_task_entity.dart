import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';

abstract interface class ITaskEntity {
  final String id;  // Уникальный идентификатор задачи
  final String title; // Заголовок задачи
  final String body; // Описание или детали задачи
  final FolderType folder; // Папка или категория, в которую входит задача
  final DateTime? date; // Дата, связанная с задачей (например, дедлайн или запланированная дата)
  final List<TaskFlag> flags; // Список флагов, описывающих статус или особенности задачи
  final TaskDuration duration; // Время на выполнение
  final DateTime createdAt; // Дата и время создания задачи
  final bool isCompleted; // Флаг, указывающий, выполнена ли задача
  final String? projectId; // ID проекта, к которому относится задача (null, если не относится к проекту)

  const ITaskEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.folder,
    this.date,
    required this.flags,
    this.duration = TaskDuration.undefined,
    required this.createdAt,
    required this.isCompleted,
    this.projectId,
  });
}
