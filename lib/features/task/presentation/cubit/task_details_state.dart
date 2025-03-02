sealed class TaskDetailsState {}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsSuccess extends TaskDetailsState {}

class TaskDetailsError extends TaskDetailsState {
  final String message;
  TaskDetailsError(this.message);
}