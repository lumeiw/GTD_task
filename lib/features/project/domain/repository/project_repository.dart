import 'package:gtd_task/features/project/domain/entity/project_entity.dart';

abstract interface class ProjectRepository {
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(Project project);
  Future<List<Project>> getAllProjects();
  Future<Project?> getProjectById(String id);
  Future<List<Project>> searchProjects(String query);
}