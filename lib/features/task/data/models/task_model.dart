//* TaskModel - модель данных, которая:
//* Имплементируемся от ITaskEntity
//* Добавляет методы toJson() и fromJson()
//* Реализует копирование (copyWith)

//? Так теперь что такое copyWith
//? так ка у нас TaskEntity const, то мы не можем просто так изменять его поля, 
//? мы будем копировать его с помошью копивиз и это уже будет новый обьект,
//? НО с измененым полем (например заголовком)
//! Метод copyWith позволяет создать копию существующего объекта, 
//! заменив только указанные поля, оставляя все остальные поля без изменений

import 'dart:convert';

import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';

class TaskModel implements ITaskEntity {
  @override
  final String id;
  
  @override
  final String title;
  
  @override
  final String body;
  
  @override
  final FolderType folder;
  
  @override
  final DateTime? date;
  
  @override
  final List<TaskFlag> flags;
  
  @override
  final DateTime createdAt;
  
  @override
  final bool isCompleted;

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

  // Создание модели из JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      folder: FolderType.values.firstWhere(
        (e) => e.name == json['folder'],
        orElse: () => FolderType.inbox,
      ),
      date: json['date'] != null 
          ? DateTime.parse(json['date'] as String)
          : null,
      flags: (json['flags'] as List<dynamic>?)
          ?.map((e) => TaskFlag.values.firstWhere(
                (flag) => flag.name == e,
                orElse: () => TaskFlag.none,
              ))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'folder': folder.name,
      'date': date?.toIso8601String(),
      'flags': flags.map((e) => e.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Метод для копирования с изменением отдельных полей
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

  // Создание из строки JSON
  factory TaskModel.fromJsonString(String jsonString) {
    return TaskModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  // Преобразование в строку JSON
  String toJsonString() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, folder: $folder, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.folder == folder &&
        other.date == date &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        folder.hashCode ^
        date.hashCode ^
        isCompleted.hashCode;
  }
}