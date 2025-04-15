import 'dart:convert';
import 'package:gtd_task/features/project/domain/entity/project_entity.dart';

class ProjectModel implements Project {
  @override
  final String id;

  @override
  final String title;
  
  @override
  final DateTime? date;

  @override
  final DateTime? createdAt;
  
  @override
  final bool isCompleted;
  
  const ProjectModel({
    required this.id,
    required this.title,
    this.date,
    this.createdAt,
    required this.isCompleted,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String, 
      title: json ['title'] as String,
      date: json['date'] !=null
        ? DateTime.parse(json['date'] as String)
        :null,
      createdAt: json['created'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
      isCompleted: json['isCompleted'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title' : title,
      'date' : date?.toIso8601String(),
      'createdAt' : createdAt?.toIso8601String(),
      'isCompleted' : isCompleted,
    };
  }


  ProjectModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory ProjectModel.fromJsonString(String jsonString) {
    return ProjectModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  

  @override
  String toString() {
    return 'ProjectModel(id: $id, title: $title, date: $date, createdAt: $createdAt, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectModel &&
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.createdAt == createdAt &&
      other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      createdAt.hashCode ^
      isCompleted.hashCode;
  }
}
