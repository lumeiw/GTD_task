import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';

abstract interface class ITaskEntity {
  int get id; // Уникальный идентификатор задачи
  String get title; // Заголовок задачи
  String get body; // Описание или детали задачи
  FolderType get folder; // Папка или категория, в которую входит задача
  DateTime?
      get date; // Дата, связанная с задачей (например, дедлайн или запланированная дата)
  String get formattedDate;
  List<TaskFlag>
      get flags; // Список флагов, описывающих статус или особенности задачи
  TaskDuration get duration; // Время на выполнение
  DateTime get createdAt; // Дата и время создания задачи
  bool get isCompleted; // Флаг, указывающий, выполнена ли задача
  String?
      get projectId; // ID проекта, к которому относится задача (null, если не относится к проекту)
}
