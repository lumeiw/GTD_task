import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';

sealed class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final List<ITaskEntity> tasks;
  TaskListLoaded(this.tasks);
}

class TaskListError extends TaskListState {
  final String message;
  TaskListError(this.message);  
}
