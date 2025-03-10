import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';

sealed class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final List<ITaskEntity> tasks;
  final FolderType? folderType;

  TaskListLoaded(
    this.tasks,
    [this.folderType]
  );
}

class TaskListError extends TaskListState {
  final String message;
  TaskListError(this.message);  
}
