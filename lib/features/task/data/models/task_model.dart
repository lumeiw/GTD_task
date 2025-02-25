//TODO: Реализация ITaskEntity для работы с данным
//* TaskModel - модель данных
//? Так теперь что такое copyWith
//? так как у нас TaskEntity const, то мы не можем просто так изменять его поля,
//? мы будем копировать его с помошью копивиз и это уже будет новый обьект,
//? НО с измененым полем (например заголовком)
//! Метод copyWith позволяет создать копию существующего объекта,
//! заменив только указанные поля, оставляя все остальные поля без изменений
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';

//* Имплементируемся от ITaskEntity
class TaskModel implements ITaskEntity {
  @override
  final String id; // Уникальный идентификатор задачи
  @override
  final String title; // Заголовок задачи
  @override
  final String body; // Описание или детали задачи
  @override
  final FolderType folder; // Папка или категория, в которую входит задача
  @override
  final DateTime?
      date; // Дата, связанная с задачей (например, дедлайн или запланированная дата)
  @override
  final List<TaskFlag>
      flags; // Список флагов, описывающих статус или особенности задачи
  @override
  final DateTime createdAt; // Дата и время создания задачи
  @override
  final bool isCompleted; // Флаг, указывающий, выполнена ли задача

  const TaskModel({
    required this.id,
    required this.title,
    required this.body,
    required this.folder,
    this.date,
    required this.flags,
    required this.createdAt,
    required this.isCompleted,
  });
//* Реализует копирование (copyWith)
  TaskModel copyWith({
    String? id,
    String? title,
    String? body,
    FolderType? folder,
    DateTime? date,
    List<TaskFlag>? flags,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      folder: folder ?? this.folder,
      date: date ?? this.date,
      flags: flags ?? this.flags,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

//* Добавляет методы toJson() и fromJson()
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'folder': folder.name,
      'date': date?.toIso8601String(),
      'flags': flags.map((flag) => flag.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      folder: FolderType.values.firstWhere((e) => e.name == json['folder']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      flags: (json['flags'] as List<dynamic>? ?? [])
          .map((flag) => TaskFlag.values.firstWhere((e) => e.name == flag))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
