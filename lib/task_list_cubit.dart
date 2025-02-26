import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:injectable/injectable.dart';

// Состояния
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

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final ITaskRepository _repository;

  TaskListCubit(this._repository) : super(TaskListInitial());

  Future<void> loadTasks() async {
    try {
      emit(TaskListLoading());
      final tasks = await _repository.getAllTasks();
      emit(TaskListLoaded(tasks));
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      emit(TaskListLoading());
      print('Обновляем список задач...');
      final tasks = await _repository.getAllTasks();
      print('Получено задач: ${tasks.length}');
      emit(TaskListLoaded(tasks));
    } catch (e) {
      print('Ошибка при обновлении: $e');
      emit(TaskListError(e.toString()));
    }
  }
}