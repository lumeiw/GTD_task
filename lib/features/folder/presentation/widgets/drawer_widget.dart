

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            
            child: Text(
              
              'GTD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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

          ExpansionTile(
            leading: const Icon(Icons.folder, color: Colors.yellow),
            title: const Text(
              'Проекты',
              style: TextStyle(),
            ),
            children: [],
          ),
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
    return ListTile(
      leading: Icon(folder.icon, ),
      title: Text(
        folder.text,
        style: TextStyle(),
      ),
      onTap: () {
        if (onTap != null) {
          onTap?.call();
        } else {
          context.read<TaskListCubit>().loadTasksByFolder(folder);
          context.pop();
        }
      },
    );
  }
}
