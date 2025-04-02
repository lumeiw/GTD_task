import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/project/bloc/create/project_create_state.dart';
import 'package:gtd_task/features/project/domain/entity/project_entity.dart';
import 'package:gtd_task/features/project/domain/repository/project_repository.dart';

class CreateProjectBloc extends Cubit<CreateProjectState> {
  CreateProjectBloc({required ProjectRepository projectRepository}) 
  : _projectRepository = projectRepository,
    super(CreateProjectInitial());

  final ProjectRepository _projectRepository;

  Future<void> createProject(Project project) async {
    try {
      emit(CreateProjectLoading());
      await _projectRepository.createProject(project);
      emit(CreateProjectSuccess(project));
    } catch (e) {
      emit(CreateProjectError(e.toString()));
    }
  }

  Future<void> delete(String id) async {
    try {
      emit(CreateProjectLoading());
      await _projectRepository.deleteProject(id);
      emit(CreateProjectSuccess());
    } catch (e) {
      emit(CreateProjectError(e.toString()));
    }
  }
}