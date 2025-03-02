import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;
  
  CreateTaskCubit(this._repository, this._factory) : super(CreateTaskInitial());

  Future<void> createTask({
    required String title,
    required String body,
    required TaskDuration duration,
    FolderType folder = FolderType.inbox,
    DateTime? date,
    List<TaskFlag>? flags,
    String? projectId,
  }) async {
    try {
      emit(CreateTaskLoading());

      final task = _factory.createTask(
        title: title,
        body: body,
        folder: folder,
        duration: duration,
        date: date,
        flags: flags,
        projectId: projectId,
      );

      await _repository.createTask(task);
      emit(CreateTaskSuccess(task));
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> updateTask(
    ITaskEntity task, {
    String? title,
    String? body,
    FolderType? folder,
    TaskDuration? duration,
    DateTime? date,
    List<TaskFlag>? flags,
    String? projectId,
    bool? isCompleted,
  }) async {
    try {
      emit(CreateTaskLoading());

      final updatedTask = _factory.copyTask(
        task,
        title: title,
        body: body,
        folder: folder,
        duration: duration,
        date: date,
        flags: flags,
        projectId: projectId,
        isCompleted: isCompleted,
      );

      await _repository.updateTask(updatedTask);
      emit(CreateTaskSuccess(updatedTask));
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      emit(CreateTaskLoading());
      await _repository.deleteTask(id);
      emit(CreateTaskSuccess());
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }
}