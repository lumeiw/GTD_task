import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/project/bloc/project_task/project_task_state.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProjectTaskBloc extends Cubit<ProjectTaskState> {
  ProjectTaskBloc(this._repository) : super(ProjectTaskInitial());
  
  final ITaskRepository _repository;
  
  Future<void> loadTasksByProject (String projectId) async {
    try {
      emit(ProjectTaskLoading());
      final tasks = await _repository.getTasksByProject(projectId);
      emit(ProjectTaskSuccess(tasks));
    } catch (e) {
      emit(ProjectTaskError(e.toString()));
    }
  }
}
