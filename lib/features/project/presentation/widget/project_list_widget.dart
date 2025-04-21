import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/project/bloc/create/project_create_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_state.dart';
import 'package:gtd_task/features/project/data/model/project_model.dart';

class ProjectListWidget extends StatelessWidget {
  const ProjectListWidget({super.key});

  void _createProjectDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? const Color(0xFF424242)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Новый проект',
          style: TextStyle(
            color: colorScheme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Название проекта',
            hintStyle: TextStyle(
              color: colorScheme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            filled: true,
            fillColor: colorScheme.brightness == Brightness.dark
                ? const Color(0xFF616161)
                : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
          ),
          style: TextStyle(
            color: colorScheme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: colorScheme.brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final project = ProjectModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(), // Чистый числовой ID
                  title: controller.text.trim(),
                  isCompleted: false,
                );
                context.read<CreateProjectBloc>().createProject(project);
                context.read<ProjectListBloc>().load();
                context.pop();
              }
            },
            child: Text(
              'Создать',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ProjectListBloc, ProjectListState>(
          builder: (context, state) {
            if (state is ProjectListInitial) {
              context.read<ProjectListBloc>().load();
            }
            return Column(
              children: [
                if (state is ProjectListLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (state is ProjectListSuccess)
                  ...state.projects.map(
                    (project) => ListTile(
                      title: Text(
                        project.title,
                        style: TextStyle(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CreateProjectBloc>().delete(project.id);
                          context.read<ProjectListBloc>().load();
                        },
                      ),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        context.go('/project/${project.id}',
                            extra: project.title);
                      },
                    ),
                  ),
                if (state is ProjectListError)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                    color: colorScheme.onSecondary,
                  ),
                  title: Text(
                    'Добавить проект',
                    style: TextStyle(),
                  ),
                  onTap: () => _createProjectDialog(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}