import 'package:gtd_task/features/project/domain/entity/project_entity.dart';

sealed class ProjectListState {}

class ProjectListInitial extends ProjectListState {}

class ProjectListLoading extends ProjectListState {}

class ProjectListSuccess extends ProjectListState {
  final List<Project> projects;
  ProjectListSuccess(this.projects);
}

class ProjectListError extends ProjectListState {
  final String message;
  ProjectListError(this.message);
}