import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/project/bloc/create/project_create_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_state.dart';
import 'package:gtd_task/features/project/data/model/project_model.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100.0,
            decoration: const BoxDecoration(color: Colors.black),
            child: const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'GTD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Входящие',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inbox, color: Colors.white),
            title: const Text('Inbox', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<TaskListCubit>().loadTasksByFolder(FolderType.inbox);
              context.pop();
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Статусы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward, color: Colors.blue),
            title:
                const Text('В работе', style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<TaskListCubit>()
                  .loadTasksByFolder(FolderType.inProgress);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.hourglass_empty, color: Colors.yellow),
            title:
                const Text('Ожидание', style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<TaskListCubit>()
                  .loadTasksByFolder(FolderType.waiting);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.cyan),
            title: const Text('Запланировано',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<TaskListCubit>()
                  .loadTasksByFolder(FolderType.planned);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_late, color: Colors.pink),
            title: const Text('Когда-нибудь',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<TaskListCubit>()
                  .loadTasksByFolder(FolderType.someday);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title:
                const Text('Завершено', style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<TaskListCubit>()
                  .loadTasksByFolder(FolderType.completed);
              context.pop();
            },
          ),
          const ProjectListWidget(),
        ],
      ),
    );
  }
}

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
                      onTap: () {},
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
