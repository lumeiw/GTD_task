import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubit/task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;

  TaskDetailsCubit(this._repository, this._factory) : super(TaskDetailsInitial());

  Future<void> loadTask(String id) async {
    try {
      emit(TaskDetailsLoading());


      await _repository.getTaskById(id);
      emit(TaskDetailsSuccess());
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }

  Future<void> toggleComplete(ITaskEntity task) async {
    try {
      emit(TaskDetailsLoading());
      final updatedTask = _factory.copyTask(
        task,
        isCompleted: true,
      );

      await _repository.updateTask(updatedTask);
      emit(TaskDetailsSuccess());
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }

  Future<void> moveToFolder(ITaskEntity task, FolderType folder) async {
    try {
      emit(TaskDetailsLoading());
      final updatedTask = _factory.copyTask(
        task,
        folder: folder,
      );

      await _repository.updateTask(updatedTask);
      emit(TaskDetailsSuccess());
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }
}
