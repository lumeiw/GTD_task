import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/details/details_task_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;

  TaskDetailsCubit(this._repository, this._factory)
      : super(TaskDetailsInitial());

  Future<void> loadTask(int id) async {
    try {
      emit(TaskDetailsLoading());

      final task = await _repository.getTaskById(id);
      if (task != null) {
        emit(TaskDetailsLoaded(task));
      } else {
        emit(TaskDetailsError('Задача не найдена'));
      }
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }

  Future<void> toggleComplete(ITaskEntity task) async {
    try {
      emit(TaskDetailsLoading());
      final updatedTask = _factory.copyTask(
        task,
        id: task.id,
        isCompleted: !task.isCompleted,
      );

      await _repository.updateTask(updatedTask);
      emit(TaskDetailsLoaded(updatedTask));
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }

  Future<void> moveToFolder(ITaskEntity task, FolderType folder) async {
    try {
      emit(TaskDetailsLoading());
      final updatedTask = _factory.copyTask(
        task,
        id: task.id,
        folder: folder,
      );

      await _repository.updateTask(updatedTask);
      emit(TaskDetailsLoaded(updatedTask));
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }
}
