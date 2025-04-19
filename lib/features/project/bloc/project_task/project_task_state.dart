import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';

sealed class ProjectTaskState {}

class ProjectTaskInitial extends ProjectTaskState {}

class ProjectTaskLoading extends ProjectTaskState {}

class ProjectTaskSuccess extends ProjectTaskState {
  final List<ITaskEntity> tasks;

  ProjectTaskSuccess(this.tasks);
}

class ProjectTaskError extends ProjectTaskState {
  final String message;
  ProjectTaskError(this.message);
}