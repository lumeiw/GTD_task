import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/animated_task_edit_card.dart'
    show AnimatedTaskEditCard;

class TaskListItem extends StatefulWidget {
  final ITaskEntity task;
  final VoidCallback? onTap;

  const TaskListItem({
    required this.task,
    this.onTap,
    super.key,
  });

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        _toggleEdit();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isEditing ? 0 : 1,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: LightAppColors.cartColor3,
                child: ListTile(
                  leading: TaskCheckboxWidget(task: widget.task),
                  title: Text(
                    widget.task.title,
                    style: TextStyle(
                      color: LightAppColors.cartColor1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: TaskInfoWidget(task: widget.task),
                  trailing: TaskDurationWidget(duration: widget.task.duration),
                ),
              ),
            ),
            if (_isEditing)
              AnimatedTaskEditCard(
                task: widget.task,
                onClose: _toggleEdit,
              ),
          ],
        ),
      ),
    );
  }
}

class TaskCheckboxWidget extends StatelessWidget {
  final ITaskEntity task;
  const TaskCheckboxWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: Checkbox(
        value: task.isCompleted,
        fillColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return LightAppColors.cartColor6;
          }
          return LightAppColors.cartColor2;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        side: BorderSide(
          width: 2,
          color: LightAppColors.cartColor4,
        ),
        checkColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onChanged: (value) {
          final createTaskCubit = context.read<CreateTaskCubit>();

          createTaskCubit.initializeWithTask(task);

          if (value == true) {
            createTaskCubit
              ..updateField(TaskField.isCompleted, true)
              ..updateField(TaskField.folder, FolderType.completed);
          } else {
            createTaskCubit
              ..updateField(TaskField.isCompleted, false)
              ..updateField(TaskField.folder, FolderType.inbox);
          }

          createTaskCubit.saveExistingTask(task);

          final currentState = context.read<TaskListCubit>().state;
          if (currentState is TaskListLoaded) {
            context
                .read<TaskListCubit>()
                .loadTasksByFolder(currentState.folderType);
          }
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
          _buildFlags(),
          const SizedBox(width: 8),
          _buildDate(),
        ],
      ),
    );
  }

  Widget _buildFlags() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task.flags.displayText,
          style: TextStyle(color: LightAppColors.cartColor4),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.notifications_none,
            color: LightAppColors.cartColor4, size: 20),
        const SizedBox(width: 2),
        Text(
          task.formattedDate,
          style: TextStyle(color: LightAppColors.cartColor4),
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
        color: LightAppColors.cartColor2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LightAppColors.cartColor2,
          width: 2,
        ),
      ),
      child: Text(
        duration.time,
        style: TextStyle(
          color: LightAppColors.cartColor4,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
