import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_lists.dart';

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
    String formattedDate = task.date != null
        ? DateFormat('yyyy-MM-dd').format(task.date!.toLocal())
        : 'Нет даты';

    String durationText = task.duration.display;
    IconData flagIcon = _getFlagIcon(task.flags);
    IconData durationIcon = _getDurationIcon(task.duration);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: LightAppColors.backgroundColor,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.transparent,
          child: ListTile(
            tileColor: Colors.transparent,
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                final createTaskCubit = context.read<CreateTaskCubit>();
                createTaskCubit
                  ..initializeWithTask(task)
                  ..updateIsCompleted(value ?? false)
                  ..saveExistingTask(task);

                context.read<TaskListCubit>().loadTasks();
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            subtitle: Row(
              children: [
                PopupMenuButton<TaskFlag>(
                  onSelected: (flag) {
                    final createTaskCubit = context.read<CreateTaskCubit>();
                    createTaskCubit
                      ..initializeWithTask(task)
                      ..updateFlags([flag])
                      ..saveExistingTask(task);
                    context.read<TaskListCubit>().loadTasks();
                  },
                  itemBuilder: (context) => TaskDropdownLists.getFlagMenuItems(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: LightAppColors.surface,
                  constraints: BoxConstraints(maxWidth: 125),
                  child: Row(
                    children: [
                      Icon(flagIcon, color: LightAppColors.iconColor),
                      const SizedBox(width: 8),
                      Text(
                        task.flags.isNotEmpty
                            ? task.flags
                                .map((flag) => flag.toString().split('.').last)
                                .join(', ')
                            : 'None',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                PopupMenuButton<TaskDuration>(
                  onSelected: (duration) {
                    final createTaskCubit = context.read<CreateTaskCubit>();
                    createTaskCubit
                      ..initializeWithTask(task)
                      ..updateDuration(duration)
                      ..saveExistingTask(task);
                    context.read<TaskListCubit>().loadTasks();
                  },
                  itemBuilder: (context) =>
                      TaskDropdownLists.getDurationMenuItems(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: LightAppColors.surface,
                  constraints: BoxConstraints(maxWidth: 160),
                  child: Row(
                    children: [
                      Icon(durationIcon, color: LightAppColors.iconColor),
                      const SizedBox(width: 8),
                      Text(
                        durationText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.notifications_none, color: LightAppColors.iconColor),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  IconData _getFlagIcon(List<TaskFlag> flags) {
    if (flags.isEmpty) {
      return Icons.flag;
    }

    switch (flags.first) {
      case TaskFlag.priority:
        return Icons.warning;
      case TaskFlag.next:
        return Icons.check_circle;
      case TaskFlag.blocked:
        return Icons.block;
      case TaskFlag.recurring:
        return Icons.loop;
      case TaskFlag.delegated:
        return Icons.assignment_turned_in;
      default:
        return Icons.flag;
    }
  }

  IconData _getDurationIcon(TaskDuration duration) {
    switch (duration) {
      case TaskDuration.veryShort:
        return Icons.flash_on;
      case TaskDuration.short:
        return Icons.timer;
      case TaskDuration.medium:
        return Icons.timer_3;
      case TaskDuration.long:
        return Icons.access_time;
      case TaskDuration.veryLong:
        return Icons.hourglass_full;
      case TaskDuration.undefined:
        return Icons.help_outline;
    }
  }
}
