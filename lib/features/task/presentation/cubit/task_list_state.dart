sealed class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListSuccess extends TaskListState {}

class TaskListError extends TaskListState {
  final String message;
  TaskListError(this.message);  
}
