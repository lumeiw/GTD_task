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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый проект'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Название проекта'),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final project = ProjectModel(
                  id: UniqueKey().toString(),
                  title: controller.text.trim(),
                  isCompleted: false,
                );
                context.read<CreateProjectBloc>().createProject(project);
                context.read<ProjectListBloc>().load();
                context.pop();
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'Проекты',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        BlocBuilder<ProjectListBloc, ProjectListState>(
          builder: (context, state) {
            if (state is ProjectListInitial) {
              context.read<ProjectListBloc>().load();
            }
            return ExpansionTile(
              leading: const Icon(Icons.folder, color: Colors.yellow),
              title:
                  const Text('Проекты', style: TextStyle(color: Colors.white)),
              children: [
                if (state is ProjectListLoading)
                  const ListTile(
                    title: Center(child: CircularProgressIndicator()),
                  ),
                if (state is ProjectListSuccess)
                  ...state.projects.map(
                    (project) => ListTile(
                      title: Text(
                        project.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CreateProjectBloc>().delete(project.id);
                          context.read<ProjectListBloc>().load();
                        },
                      ),
                      onTap: () {
                        context.push('/project/${project.id}', extra: project.title);
                      },
                    ),
                  ),
                if (state is ProjectListError)
                  ListTile(
                    title: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.white),
                  title: const Text('Добавить проект',
                      style: TextStyle(color: Colors.white)),
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