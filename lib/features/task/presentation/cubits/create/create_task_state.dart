sealed class CreateTaskState {}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {}

class CreateTaskError extends CreateTaskState {
  final String message; 
  CreateTaskError(this.message);
}