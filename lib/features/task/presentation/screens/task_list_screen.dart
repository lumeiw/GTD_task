import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/folder/presentation/widgets/drawer_widget.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/task_list_content.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/task_app_bar.dart';
import 'package:gtd_task/features/task_action/domain/task_action_type_unem.dart';
import 'package:gtd_task/features/task_action/presentation/widget/expandable_action_button.dart';

class TaskListScreen extends StatelessWidget {
  final FolderType folderType;

  const TaskListScreen({required this.folderType, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: TaskAppBar(folderType: folderType),
      drawer: const DrawerWidget(),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          return switch (state) {
            TaskListInitial() => const SizedBox(),
            TaskListLoading() =>
              const Center(child: CircularProgressIndicator()),
            TaskListError(message: var message) => Center(
              child: Text(
                'Ошибка: $message',
                style: TextStyle(color: theme.colorScheme.onSurface)
              ),
            ),

            //* var tasks создает переменную и присваивает ей значение из поля tasks
            TaskListLoaded(tasks: var tasks) => TaskListContent(
              tasks: tasks,
            ),
          };
        },
      ),

      floatingActionButton: ExpandableActionButton(
        onActionSelected: (actionType) {
          switch (actionType) {
            case TaskActionType.createTask:
              showInlineTaskEditor(context);
              break;
            case TaskActionType.moveTask:
              break;
            case TaskActionType.autoSort:
              // Будет реализовано позже
              break;
          }
        },
      ),
    );
  }
}

