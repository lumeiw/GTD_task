import 'package:gtd_task/features/project/data/data_source/project_local_source.dart';
import 'package:gtd_task/features/project/data/model/project_model.dart';
import 'package:gtd_task/features/project/domain/entity/project_entity.dart';
import 'package:gtd_task/features/project/domain/repository/project_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl({required ProjectLocalSource localSource}) : _localSource = localSource;

  final ProjectLocalSource _localSource;


  @override
  Future<void> createProject(Project project) async {
    try {
      final projectModel = _ensureProjectModel(project);
      await _localSource.createProject(projectModel);
    } catch (e) {
      throw Exception('Ошибка загрузки проектов: $e');
    }
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      final projectModel = _ensureProjectModel(project);
      await _localSource.updateProject(projectModel);
    } catch (e) {
      throw Exception('Ошибка обновления проекта: $e');
    }
  }
  
  @override
  Future<void> deleteProject(String id) async {
    try {
      await _localSource.deleteProject(id);
    } catch (e) {
      throw Exception('Ошибка удаления проекта: $e');

    }
  }
  
  @override
  Future<List<Project>> getAllProjects() async {
    try {
      return await _localSource.getAllProjects();
    } catch (e) {
      throw Exception('Ошибка загрузки проектов: $e');
    }

  }
  
  @override
  Future<List<Project>> searchProjects(String query) async {
    try {
      return await _localSource.searchProjects(query);
    } catch (e) {
      throw Exception('Ошибка поиска проектов: $e');
    }
  }

  ProjectModel _ensureProjectModel(Project project) {
    if (project is ProjectModel) {
      return project;
    }

    return ProjectModel(
      id: project.id, 
      title: project.title,
      date: project.date,
      createdAt: project.createdAt,
      isCompleted: project.isCompleted,
    );
  }
}