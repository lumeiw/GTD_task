import 'package:flutter/material.dart';

enum FolderType {
  inbox, // Входящие
  inProgress, // В работе
  waiting, // Ожидание
  planned, // В планах
  someday, // Когда-нибудь
  completed;  // Завершенные
  // archived; // Архив
  

  
  IconData get icon{
    return switch (this){
      FolderType.inbox => Icons.inbox,
      FolderType.planned => Icons.calendar_month_outlined,
      FolderType.waiting => Icons.hourglass_empty,
      FolderType.someday => Icons.sunny_snowing,
      FolderType.inProgress => Icons.arrow_forward,
      FolderType.completed => Icons.check_circle_outline_sharp,
      // FolderType.archived => Icons.archive,
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
      // FolderType.archived => 'Архив',
    };
  }

}