import 'package:gtd_task/core/storage/local_storage.dart';
import 'package:gtd_task/features/project/data/model/project_model.dart';

class ProjectLocalSource {
  final LocalStorage _storage;
  static const String _keyPrefix = 'project_';

  ProjectLocalSource(this._storage);

  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final projectKeys = _storage.getKeysByPrefix(_keyPrefix);

      final projects = <ProjectModel>[];
      for (final key in projectKeys) {
        final jsonString = _storage.getString(key);
        if (jsonString != null) {
          projects.add(ProjectModel.fromJsonString(jsonString));
        }
      }
      return projects;
    } catch (e) {
      throw Exception('Ошибка при получении проектов:$e');
    }
  }

  Future<ProjectModel?> getProjectById(String id) async {
    try {
      final key = _getKeyForId(id);
      final jsonString = _storage.getString(key);

      if (jsonString == null) {
        return null;
      }

      return ProjectModel.fromJsonString(jsonString);
    } catch (e) {
      throw Exception('Ошибка при получении проекта: $e');
    }
  }


  Future<void> createProject(ProjectModel project) async {
    try {
      await saveProject(project);
    } catch (e) {
      throw Exception('Ошибка при создании проекта: $e');
    }
  }

  Future<void> saveProject(ProjectModel project) async {
    try {
      final key = _getKeyForId(project.id);
      await _storage.setString(key, project.toJsonString());
    } catch (e) {
      throw Exception('Ошибка при сохранении проекта: $e');
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      await saveProject(project);
    } catch (e) {
      throw Exception('Ошибка при обновлении проекта: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final key = _getKeyForId(id);
      await _storage.remove(key);
    } catch (e) {
      throw Exception('Ошибка при удалении проекта: $e');
    }
  }

  Future<List<ProjectModel>> searchProjects (String query) async {
    try {
      final allProjects = await getAllProjects();
      final lowercaseQuery = query.toLowerCase();

      return allProjects.where((project) {
        return project.title.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Ошибка при поиске прокта: $e');
    }
  }

  String _getKeyForId(String id) {
    return '$_keyPrefix$id';
  }
  
}