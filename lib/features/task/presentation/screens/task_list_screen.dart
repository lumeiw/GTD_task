import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';
import 'package:gtd_task/features/folder/presentation/widgets/drawer_widget.dart';
import 'package:gtd_task/features/task_action/domain/task_action_type_unem.dart';
import 'package:gtd_task/features/task_action/presentation/widget/expandable_action_button.dart';

class TaskListScreen extends StatelessWidget {
  final FolderType folderType;
  
  const TaskListScreen({
    required this.folderType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Загружаем задачи при построении виджета
    context.read<TaskListCubit>().loadTasksByFolder(folderType);
    
    return Scaffold(
      backgroundColor: LightAppColors.cartColor2,
      appBar: AppBar(
        title: BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, state) {
            return Text(
              _getFolderTitle(state is TaskListLoaded ? state.folderType ?? folderType : folderType),
              style: TextStyle(color: theme.colorScheme.onSurface),
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
      ),
      drawer: const DrawerWidget(),

      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          return switch (state) {
            TaskListInitial() => const SizedBox(),
            TaskListLoading() => const Center(child: CircularProgressIndicator()),
            TaskListError(message: var message) => Center(
                child: Text('Ошибка: $message',
                    style: TextStyle(color: theme.colorScheme.onSurface))),
            TaskListLoaded(tasks: var tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Form(
                    child: TaskListItem(
                      task: task,
                      onTap: () => _showEditTask(context, task),
                    ),
                  );
                },
              ),
          };
        },
      ),
      floatingActionButton: ExpandableActionButton(
        onActionSelected: (actionType) {
          switch (actionType) {
            case TaskActionType.createTask:
              _showEditTask(context);
              break;
            case TaskActionType.moveTask:
              // Будет реализовано позже
              break;
            case TaskActionType.autoSort:
              // Будет реализовано позже
              break;
          }
        },
      ),
    );
  }

  void _showEditTask(BuildContext context, [ITaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LightAppColors.surface,
      builder: (_) => BlocProvider(
        create: (_) => getIt<CreateTaskCubit>(),
        child: TaskEditCard(
          task: task,
          onSaved: () {
            Navigator.pop(context);
            context.read<TaskListCubit>().loadTasksByFolder(folderType);
          },
        ),
      ),
    );
  }

  String _getFolderTitle(FolderType folder) {
    return switch (folder) {
      FolderType.inbox => 'Входящие',
      FolderType.inProgress => 'В работе',
      FolderType.waiting => 'Ожидание',
      FolderType.planned => 'Запланировано',
      FolderType.someday => 'Когда-нибудь',
      FolderType.completed => 'Завершено',
      FolderType.archived => 'Архив',
    };
  }
}
