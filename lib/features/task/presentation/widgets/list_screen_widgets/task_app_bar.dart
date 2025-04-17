import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FolderType folderType;
  const TaskAppBar({super.key, required this.folderType});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.primary,
      title: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          final currentFolder =
              state is TaskListLoaded ? state.folderType : folderType;
          return Text(
            currentFolder.text,
            style: TextStyle(color: colorScheme.onSurface),
          );
        },
      ),
      leading: Builder(
        builder: (innerContext) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(innerContext).openDrawer();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
