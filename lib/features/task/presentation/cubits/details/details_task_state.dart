import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';

sealed class TaskDetailsState {}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final ITaskEntity task;
  TaskDetailsLoaded(this.task);
}

class TaskDetailsError extends TaskDetailsState {
  final String message;
  TaskDetailsError(this.message);
}