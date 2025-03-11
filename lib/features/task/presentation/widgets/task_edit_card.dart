import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_lists.dart';

class TaskEditCard extends StatelessWidget {
  final ITaskEntity? task;
  final VoidCallback onSaved;

  const TaskEditCard({
    this.task,
    required this.onSaved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.theme;
    final colorScheme = theme.colorScheme;
    final createTaskCubit = context.read<CreateTaskCubit>();

    if (task != null) {
      createTaskCubit.initializeWithTask(task!);
    }

    return BlocConsumer<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          onSaved();
        } else if (state is CreateTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is CreateTaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // final editingState = state is CreateTaskEditing ? state : null;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              child: SizedBox(
                width: 351,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: TextFormField(
                                        initialValue:
                                            (state is CreateTaskEditing)
                                                ? state.title
                                                : '',
                                        decoration: InputDecoration(
                                          hintText: 'Новая задача',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (value) => createTaskCubit.updateField(TaskField.title, value),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 17.0, top: 3.0),
                                child: TextFormField(
                                  initialValue: (state is CreateTaskEditing)
                                      ? state.body
                                      : '',
                                  decoration: InputDecoration(
                                    hintText: 'Заметки',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) => createTaskCubit.updateField(TaskField.body, value),
                                  maxLines: null,
                                  minLines: 1,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => task == null
                                          ? createTaskCubit.saveNewTask()
                                          : createTaskCubit.saveExistingTask(task!),
                                          icon: Icon(
                                            Icons.save,
                                            color: LightAppColors.cartColor6,
                                          ),
                                          tooltip: 'Сохранить',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                              minWidth: 32, minHeight: 32),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        PopupMenuButton<FolderType>(
                                          icon: Icon(Icons.folder_open,
                                              color: LightAppColors.cartColor4),
                                          padding: EdgeInsets.zero,
                                          onSelected:  (FolderType selectedFolder){
                                            createTaskCubit.updateField(TaskField.folder, selectedFolder);
                                          },
                                          color: colorScheme.surface,
                                          itemBuilder: (context) =>
                                              FolderType.values.map((folder) {
                                            return PopupMenuItem(
                                              value: folder,
                                              child: Text(
                                                folder
                                                    .toString()
                                                    .split('.')
                                                    .last,
                                                style: TextStyle(
                                                    color:
                                                        colorScheme.onSurface),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        PopupMenuButton<TaskFlag>(
                                          icon: Icon(Icons.bookmark_border,
                                              color: LightAppColors.cartColor4),
                                          padding: EdgeInsets.zero,
                                          onSelected: (TaskFlag selectedFlag) {
                                            final currentFlags = (state is CreateTaskEditing)
                                              ? List<TaskFlag>.from(state.flags)
                                              : [];
                                            if (currentFlags.contains(selectedFlag)){
                                              currentFlags.remove(selectedFlag);
                                            } else {
                                              currentFlags.add(selectedFlag);
                                            }
                                            createTaskCubit.updateField(TaskField.flags, currentFlags);
                                          },
                                          color: colorScheme.surface,
                                          itemBuilder: (context) =>
                                              TaskDropdownLists
                                                  .getFlagMenuItems(
                                                      colorScheme.onSurface),
                                        ),
                                        PopupMenuButton<TaskDuration>(
                                          icon: Icon(Icons.access_time,
                                              color: LightAppColors.cartColor4),
                                          padding: EdgeInsets.zero,
                                          onSelected: (TaskDuration selectedDuration) {
                                            createTaskCubit.updateField(TaskField.duration, selectedDuration);
                                          },
                                          color: colorScheme.surface,
                                          itemBuilder: (context) =>
                                              TaskDropdownLists
                                                  .getDurationMenuItems(
                                                      colorScheme.onSurface),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.notifications_none,
                                            color: LightAppColors.cartColor4,
                                          ),
                                          onPressed: () async {
                                            final selectedDate = await showDatePicker(
                                              context: context,
                                              initialDate: (state is CreateTaskEditing && state.date != null)
                                                ? state.date!
                                                : DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (selectedDate != null) {
                                              createTaskCubit.updateField(TaskField.date, selectedDate);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
