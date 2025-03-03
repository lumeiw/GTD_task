import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/core/theme/app_theme.dart';

class TaskListItem extends StatelessWidget {
  final ITaskEntity task;
  final VoidCallback onTap;

  const TaskListItem({
    required this.task,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightAppColors.backgroundColor,
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            final createTaskCubit = context.read<CreateTaskCubit>();
            createTaskCubit
              ..initializeWithTask(task)
              ..updateIsCompleted(value ?? false)
              ..saveExistingTask(task);

            // Обновляем список после изменения статуса
            context.read<TaskListCubit>().loadTasks();
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        onTap: onTap,
      ),
    );
  }
}