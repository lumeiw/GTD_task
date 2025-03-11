import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:intl/intl.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';

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





    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 13.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: LightAppColors.cartColor3,
          child: ListTile(
            leading: Transform.scale(
              scale: 1.0,
              child: Checkbox(
                value: task.isCompleted,
                fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
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
                  createTaskCubit
                    .initializeWithTask(task);
                    // Сначала обновляем все необходимые поля
                    if (value == true) {
                      createTaskCubit
                        ..updateField(TaskField.isCompleted, true)
                        ..updateField(TaskField.folder, FolderType.completed);
                    } else {
                      createTaskCubit
                        ..updateField(TaskField.isCompleted, false)
                        ..updateField(TaskField.folder, FolderType.inbox);
                    }
                   
                    // Затем сохраняем задачу
                    createTaskCubit.saveExistingTask(task);
                   
                    // Обновляем список задач текущей папки
                    final currentState = context.read<TaskListCubit>().state;
                    if (currentState is TaskListLoaded) {
                      context.read<TaskListCubit>().loadTasksByFolder(currentState.folderType ?? FolderType.inbox);
                    }
                },
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(color: LightAppColors.cartColor1,fontWeight: FontWeight.w500 ),
            ),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 0),
                      Text(
                        task.flags.isNotEmpty
                            ? task.flags.map((flag) => '@${flag.toString().split('.').last.toLowerCase()}').join(' ')
                            : '@none',
                        style: TextStyle(color: LightAppColors.cartColor4),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_none, color: LightAppColors.cartColor4, size: 20,),
                      const SizedBox(width: 2),
                      Text(
                        formattedDate,
                        style: TextStyle(color: LightAppColors.cartColor4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Container(
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
                _formatDuration(task.duration),
                style: TextStyle(
                  color: LightAppColors.cartColor4,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  

    

  

  String _formatDuration(TaskDuration duration) {
    switch (duration) {
      case TaskDuration.veryShort:
        return '1m';
      case TaskDuration.short:
        return '5m';
      case TaskDuration.medium:
        return '10m';
      case TaskDuration.long:
        return '30m';
      case TaskDuration.veryLong:
        return '1h';
      case TaskDuration.undefined:
        return '?';
    }
  }
}
