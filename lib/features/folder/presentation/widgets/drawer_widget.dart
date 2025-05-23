import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/project/presentation/widget/project_list_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      width: 250.0,
      backgroundColor: colorScheme.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 5.0),
                  child: IconButton(
                    icon: Icon(Icons.settings_outlined,
                        color: colorScheme.onSecondary),
                    onPressed: () {
                      context.push('/settings');
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          //
          SectionTitle(title: 'Входящие'),
          DrawerTile(folder: FolderType.inbox),
          //
          SectionTitle(title: 'Статусы'),
          DrawerTile(folder: FolderType.inProgress),
          DrawerTile(folder: FolderType.waiting),
          DrawerTile(folder: FolderType.planned),
          DrawerTile(folder: FolderType.someday),
          DrawerTile(folder: FolderType.completed),
          //
          SectionTitle(title: 'Проекты'),
          const ProjectListWidget(),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        top: 16,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({super.key, required this.folder, this.onTap});

  final VoidCallback? onTap;
  final FolderType folder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        folder.icon,
        color: colorScheme.onSecondary,
      ),
      title: Text(
        folder.text,
        style: TextStyle(),
      ),
      onTap: () {
        if (onTap != null) {
          onTap?.call();
        } else {
          context.read<TaskListCubit>().loadTasksByFolder(folder);
          Scaffold.of(context).closeDrawer();
          context.go('/task-list-screen/${folder.name}');
        }
      },
    );
  }
}