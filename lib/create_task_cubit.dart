import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';

@injectable
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;

  CreateTaskCubit(this._repository, this._factory) : super(CreateTaskInitial());

  Future<void> createTask(
    String title, 
    String body, 
    TaskDuration duration,
  ) async {
    try {
      emit(CreateTaskLoading());
      print('Создаем задачу: $title, $body, $duration');

      final task = _factory.createTask(
        title: title,
        body: body,
        folder: FolderType.inbox,
        duration: duration,
      );
      
      print('Задача создана через фабрику: $task');

      await _repository.createTask(task);
      print('Задача сохранена в репозитории');
      
      emit(CreateTaskSuccess());
    } catch (e) {
      print('Ошибка при создании задачи: $e');
      emit(CreateTaskError(e.toString()));
    }
  }
}

sealed class CreateTaskState {}
class CreateTaskInitial extends CreateTaskState {}
class CreateTaskLoading extends CreateTaskState {}
class CreateTaskSuccess extends CreateTaskState {}
class CreateTaskError extends CreateTaskState {
  final String message;
  CreateTaskError(this.message);
}