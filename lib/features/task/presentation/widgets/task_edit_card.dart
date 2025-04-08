import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const TaskEditCard({this.task, required this.onSaved, super.key});


  @override
  Widget build(BuildContext context) {
    final createTaskCubit = context.read<CreateTaskCubit>();

    if (task != null) {
      createTaskCubit.initializeWithTask(task!);
    }

    return BlocConsumer<CreateTaskCubit, CreateTaskState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        if (state is CreateTaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Form(
              child: TaskCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TaskTitleField(
                      initialValue:
                          state is CreateTaskEditing ? state.title : null,
                      onChanged: (value) =>
                          createTaskCubit.updateField(TaskField.title, value),
                    ),
                    TaskNotesField(
                      initialValue:
                          state is CreateTaskEditing ? state.body : null,
                      onChanged: (value) =>
                          createTaskCubit.updateField(TaskField.body, value),
                    ),
                    const SizedBox(height: 12),
                    TaskActionBar(
                        task: task, cubit: createTaskCubit, state: state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, CreateTaskState state) {
    if (state is CreateTaskSuccess) {
      onSaved();
    } else if (state is CreateTaskError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${state.message}')),
      );
    }
  }
}

class TaskTitleField extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const TaskTitleField({super.key, this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 3.0),
      child: TextFormField(
        initialValue: initialValue ?? '',
        decoration: InputDecoration(
          hintText: 'Новая задача',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 15,
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 18,
          color: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class TaskNotesField extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const TaskNotesField({super.key, this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 3.0),
      child: TextFormField(
        initialValue: initialValue ?? '',
        decoration: InputDecoration(
          hintText: 'Заметки',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
        maxLines: null,
        minLines: 1,
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class TaskActionBar extends StatelessWidget {
  final ITaskEntity? task;
  final CreateTaskCubit cubit;
  final CreateTaskState state;

  const TaskActionBar(
      {super.key, this.task, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSaveButton(context),
        Row(
          children: [
            _buildFolderButton(context),
            _buildFlagsButton(context),
            _buildDurationButton(context),
            _buildDateButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (task == null) {
          cubit.saveNewTask();
        } else {
          cubit.saveExistingTask(task!);
        }
      },
      icon: Icon(
        Icons.save,
        color: Theme.of(context).colorScheme.secondary,
      ),
      tooltip: 'Сохранить',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  Widget _buildFolderButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<FolderType>(
      icon: Icon(Icons.folder_open, color: colorScheme.onSecondary),
      padding: EdgeInsets.zero,
      onSelected: (FolderType selectedFolder) {
        cubit.updateField(TaskField.folder, selectedFolder);
      },
      color: colorScheme.onBackground,
      itemBuilder: (context) => FolderType.values.map((folder) {
        return PopupMenuItem(
          value: folder,
          child: Text(
            folder.toString().split('.').last,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFlagsButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<TaskFlag>(
      icon: Icon(Icons.bookmark_border, color: colorScheme.onSecondary),
      padding: EdgeInsets.zero,
      onSelected: (TaskFlag selectedFlag) {
        final currentFlags = (state is CreateTaskEditing)
            ? List<TaskFlag>.from((state as CreateTaskEditing).flags)
            : [];
        if (currentFlags.contains(selectedFlag)) {
          currentFlags.remove(selectedFlag);
        } else {
          currentFlags.add(selectedFlag);
        }
        cubit.updateField(TaskField.flags, currentFlags);
      },
      color: colorScheme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Скругление углов
      ),
      itemBuilder: (context) {
        return TaskDropdownLists.getFlagMenuItems(colorScheme.onSurface)
            .map((item) {
          return PopupMenuItem<TaskFlag>(
            value: item.value,
            child: Row(
              children: [
                if ((state is CreateTaskEditing) &&
                    (state as CreateTaskEditing).flags.contains(item.value))
                  Icon(Icons.check,
                      color: colorScheme.onSecondary,
                      size: 16), // Уменьшенная галочка
                SizedBox(width: 8),
                Text(
                  item.value.toString().split('.').last,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildDurationButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<TaskDuration>(
      icon: Icon(Icons.access_time,
          color: Theme.of(context).colorScheme.onSecondary),
      padding: EdgeInsets.zero,
      onSelected: (TaskDuration selectedDuration) {
        cubit.updateField(TaskField.duration, selectedDuration);
      },
      color: colorScheme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Скругление углов
      ),
      itemBuilder: (context) {
        return TaskDropdownLists.getDurationMenuItems(colorScheme.onSurface)
            .map((item) {
          return PopupMenuItem<TaskDuration>(
            value: item.value,
            child: Row(
              children: [
                if ((state is CreateTaskEditing) &&
                    (state as CreateTaskEditing).duration == item.value)
                  Icon(
                    Icons.check,
                    color: colorScheme.onSecondary,
                    size: 16,
                  ), // Галочка
                SizedBox(width: 8),
                Text(
                  item.value.toString().split('.').last,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          );
        }).toList();
      },
      constraints: BoxConstraints(maxWidth: 180),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.notifications_none,
          color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: (state is CreateTaskEditing &&
                  (state as CreateTaskEditing).date != null)
              ? (state as CreateTaskEditing).date!
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          cubit.updateField(TaskField.date, selectedDate);
        }
      },
    );
  }
}

class TaskCardContainer extends StatelessWidget {
  final Widget child;

  const TaskCardContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 351,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
