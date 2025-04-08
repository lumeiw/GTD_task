import 'package:flutter/material.dart';

enum FolderType {
  inbox, // Входящие
  planned, // В планах
  waiting, // Ожидание
  someday, // Когда-нибудь
  inProgress, // В работе
  completed,  // Завершенные
  archived; // Архив
  

  
  IconData get icon{
    return switch (this){
      FolderType.inbox => Icons.inbox,
      FolderType.planned => Icons.calendar_today,
      FolderType.waiting => Icons.hourglass_empty,
      FolderType.someday => Icons.assignment_late,
      FolderType.inProgress => Icons.arrow_forward,
      FolderType.completed => Icons.check_circle,
      FolderType.archived => Icons.archive,
    };
  }

      
  String get text {
    return switch (this) {
      FolderType.inbox => 'Входящие',
      FolderType.inProgress => 'В работе',
      FolderType.waiting => 'Ожидание',
      FolderType.planned => 'Запланировано',
      FolderType.someday => 'Когда-нибудь',
      FolderType.completed => 'Завершено',
      FolderType.archived => 'Архив',
    };
  }

}