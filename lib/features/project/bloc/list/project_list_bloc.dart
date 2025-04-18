import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_state.dart';
import 'package:gtd_task/features/project/domain/repository/project_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProjectListBloc extends Cubit<ProjectListState> {
  ProjectListBloc({required ProjectRepository projectRepository})
      : _projectrepository = projectRepository,
        super(ProjectListInitial());

  final ProjectRepository _projectrepository;

  Future<void> load() async {
    try {
      emit(ProjectListLoading());
      final projects = await _projectrepository.getAllProjects();
      emit(ProjectListSuccess(projects));
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }

  Future<void> search(String query) async {
    try {
      emit(ProjectListLoading());
      final projects = await _projectrepository.searchProjects(query);
      emit(ProjectListSuccess(projects));
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }
}
