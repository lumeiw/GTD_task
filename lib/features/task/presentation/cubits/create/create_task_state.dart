import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';

sealed class CreateTaskState {}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final ITaskEntity? task;
  
  CreateTaskSuccess([this.task]);
}

class CreateTaskError extends CreateTaskState {
  final String message; 
  CreateTaskError(this.message);
}