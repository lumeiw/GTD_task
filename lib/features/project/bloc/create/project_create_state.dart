import 'package:gtd_task/features/project/domain/entity/project_entity.dart';

abstract class CreateProjectState {}

class CreateProjectInitial extends CreateProjectState {}

class CreateProjectLoading extends CreateProjectState {}

class CreateProjectSuccess extends CreateProjectState {
  final Project? project;

  CreateProjectSuccess([this.project]);
}

class CreateProjectError extends CreateProjectState {
  final String message;
  CreateProjectError(this.message);
}