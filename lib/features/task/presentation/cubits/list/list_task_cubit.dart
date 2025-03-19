import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final ITaskRepository _repository;

  TaskListCubit(this._repository) : super(TaskListInitial()) {
    loadTasksByFolder(FolderType.inbox);
  }

  Future<void> loadTasksByFolder(FolderType folder) async {
    try {
      emit(TaskListLoading());

      final tasks = await _repository.getTasksByFolder(folder);
      emit(TaskListLoaded(tasks, folder));
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  void updateTasks(ITaskEntity updatedTasks) {}
}
