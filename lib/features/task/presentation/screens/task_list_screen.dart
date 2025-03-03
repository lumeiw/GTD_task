import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Входящие',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: LightAppColors.backgroundColor,
      ),
      backgroundColor: LightAppColors.backgroundColor,
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          return switch (state) {
            TaskListInitial() => const SizedBox(),
            TaskListLoading() =>
              const Center(child: CircularProgressIndicator()),
            TaskListError(message: var message) => Center(
                child: Text('Ошибка: $message',
                    style: TextStyle(color: theme.colorScheme.onBackground))),
            TaskListLoaded(tasks: var tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Form(
                    child: Container(
                      color: theme.colorScheme.surface,
                      child: TaskListItem(
                        task: task,
                        onTap: () => _showEditTask(context, task),
                      ),
                    ),
                  );
                },
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditTask(context),
        backgroundColor: LightAppColors.surface,
        child: Icon(Icons.add, color: LightAppColors.iconColor),
      ),
    );
  }

  void _showEditTask(BuildContext context, [ITaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LightAppColors.surface,
      builder: (_) => BlocProvider(
        create: (_) => GetIt.I<CreateTaskCubit>(),
        child: TaskEditCard(
          task: task,
          onSaved: () {
            Navigator.pop(context);
            context.read<TaskListCubit>().loadTasks();
          },
        ),
      ),
    );
  }
}
