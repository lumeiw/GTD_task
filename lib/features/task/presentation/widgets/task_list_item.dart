import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';

class TaskListItem extends StatelessWidget {
  final ITaskEntity task;
  final VoidCallback onTap;

  const TaskListItem({required this.task, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Theme.of(context).colorScheme.background,
          child: ListTile(
            leading: TaskCheckboxWidget(
              key: ValueKey('checkbox-${task.id}'),
              task: task,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: TaskInfoWidget(task: task),
            trailing: TaskDurationWidget(duration: task.duration),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class TaskCheckboxWidget extends StatefulWidget {
  final ITaskEntity task;
  const TaskCheckboxWidget({super.key, required this.task});

  @override
  State<TaskCheckboxWidget> createState() => _TaskCheckboxWidgetState();
}

class _TaskCheckboxWidgetState extends State<TaskCheckboxWidget> {
  late bool isChecked;
  bool _isProcessing = false; //? Флаг для отслеживания процесса обновления

  @override
  void initState() {
    super.initState();
    isChecked = widget.task.isCompleted;
  }

  @override
  void didUpdateWidget(TaskCheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.isCompleted != widget.task.isCompleted) {
      isChecked = widget.task.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: Checkbox(
        value: isChecked,
        fillColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.secondary;
          }
          return Theme.of(context).colorScheme.onBackground;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        checkColor: Theme.of(context).colorScheme.onPrimary,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onChanged: _isProcessing
            ? null
            : (value) {
                if (_isProcessing) return;
                _isProcessing = true;

                final createTaskCubit = context.read<CreateTaskCubit>();
                final taskListCubit = context.read<TaskListCubit>();
                final TaskListState currentState = taskListCubit.state;
                final FolderType? currentFolder = currentState is TaskListLoaded
                    ? currentState.folderType
                    : null;

                setState(() {
                  isChecked = value ?? false;
                });

                Future.delayed(const Duration(milliseconds: 400), () {
                  if (!mounted) {
                    _isProcessing = false;
                    return;
                  }

                  createTaskCubit.initializeWithTask(widget.task);

                  if (value == true) {
                    createTaskCubit
                      ..updateField(TaskField.isCompleted, true)
                      ..updateField(TaskField.folder, FolderType.completed);
                  } else {
                    createTaskCubit
                      ..updateField(TaskField.isCompleted, false)
                      ..updateField(TaskField.folder, FolderType.inbox);
                  }

                  createTaskCubit.saveExistingTask(widget.task);

                  if (currentFolder != null) {
                    taskListCubit.loadTasksByFolder(currentFolder);
                  }

                  _isProcessing = false;
                });
              },
      ),
    );
  }
}

class TaskInfoWidget extends StatelessWidget {
  final ITaskEntity task;
  const TaskInfoWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFlags(context),
          const SizedBox(width: 8),
          _buildDate(context),
        ],
      ),
    );
  }

  Widget _buildFlags(
    BuildContext context,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task.flags.displayText,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ],
    );
  }

  Widget _buildDate(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.notifications_none,
            color: Theme.of(context).colorScheme.onSecondary, size: 20),
        const SizedBox(width: 2),
        Text(
          task.formattedDate,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ],
    );
  }
}

class TaskDurationWidget extends StatelessWidget {
  final TaskDuration duration;
  const TaskDurationWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Text(
        duration.time,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
