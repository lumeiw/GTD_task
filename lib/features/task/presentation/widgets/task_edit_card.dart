// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_state.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';

class TaskEditCard extends StatelessWidget {
  final ITaskEntity? task;
  final VoidCallback onSaved;

  const TaskEditCard({this.task, required this.onSaved, super.key});

  @override
  Widget build(BuildContext context) {
    // Создаем новый BlocProvider для каждой задачи
    return BlocProvider<CreateTaskCubit>(
      // Новый экземпляр Cubit с инициализацией для задачи
      create: (context) {
        final cubit =
            CreateTaskCubit(getIt<ITaskRepository>(), getIt<TaskFactory>());

        // Инициализируем сразу, если есть задача
        if (task != null) {
          cubit.initializeWithTask(task!);
        }

        return cubit;
      },
      child: BlocConsumer<CreateTaskCubit, CreateTaskState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is CreateTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final createTaskCubit = context.read<CreateTaskCubit>();

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
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
                        task: task,
                        cubit: createTaskCubit,
                        state: state,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, CreateTaskState state) {
    if (state is CreateTaskSuccess) {
      final taskListCubit = context.read<TaskListCubit>();
      final currentState = taskListCubit.state;
      if (currentState is TaskListLoaded) {
        taskListCubit.loadTasksByFolder(currentState.folderType);
      }

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

  const TaskTitleField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 3.0),
      child: TextFormField(
        initialValue: initialValue ?? '',
        cursorColor: colorScheme.onSurface.withOpacity(0.7),
        showCursor: true,
        cursorHeight: 15,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'Новая задача',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 18,
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 18,
          color: colorScheme.surface,
        ),
      ),
    );
  }
}

class TaskNotesField extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const TaskNotesField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 3.0),
      child: TextFormField(
        initialValue: initialValue ?? '',
        cursorColor: colorScheme.onSurface.withOpacity(0.7),
        showCursor: true,
        cursorHeight: 15,
        decoration: InputDecoration(
          hintText: 'Заметки',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
        maxLines: null,
        minLines: 1,
        style: TextStyle(
          fontSize: 16,
          color: colorScheme.surface,
        ),
      ),
    );
  }
}

class TaskActionBar extends StatelessWidget {
  final ITaskEntity? task;
  final CreateTaskCubit cubit;
  final CreateTaskState state;

  const TaskActionBar({
    super.key,
    this.task,
    required this.cubit,
    required this.state,
  });

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

    return BlocBuilder<ProjectListBloc, ProjectListState>(
      builder: (context, state) {
        // Загружаем список проектов при первом показе
        if (state is ProjectListInitial) {
          context.read<ProjectListBloc>().load();
          return Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onSecondary,
              ),
            ),
          );
        }

        // Показываем индикатор загрузки
        if (state is ProjectListLoading) {
          return Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onSecondary,
              ),
            ),
          );
        }

        // В случае ошибки показываем иконку с сообщением об ошибке
        if (state is ProjectListError) {
          return IconButton(
            icon: Icon(Icons.error_outline, color: Colors.red),
            tooltip: state.message,
            onPressed: () => context.read<ProjectListBloc>().load(),
          );
        }

        // Если есть проекты, показываем их в выпадающем меню
        final projects = state is ProjectListSuccess ? state.projects : [];

        return PopupMenuButton<String>(
          icon: Icon(Icons.folder_open, color: colorScheme.onSecondary),
          tooltip: 'Проекты',
          padding: EdgeInsets.zero,
          onSelected: (String projectId) {
            // Обновляем задачу с выбранным проектом
            cubit.updateField(TaskField.projectId, projectId);
          },
          color: colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          itemBuilder: (context) {
            if (projects.isEmpty) {
              return [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Text(
                    'Нет доступных проектов',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ];
            }

            return projects.map((project) {
              final selectedProjectId = (state is CreateTaskEditing)
                  ? (state as CreateTaskEditing).projectId
                  : null;
              final isSelected = project.id == selectedProjectId;

              return PopupMenuItem<String>(
                value: project.id,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check, color: colorScheme.onSecondary, size: 16),
                    SizedBox(width: isSelected ? 8 : 0),
                    Text(
                      project.title,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  Widget _buildFlagsButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<TaskFlag>(
      icon: Icon(Icons.bookmark_border, color: colorScheme.onSecondary),
      tooltip: 'Флаги',
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
        borderRadius: BorderRadius.circular(15),
      ),
      itemBuilder: (context) {
        final selectedFlags = (state is CreateTaskEditing)
            ? (state as CreateTaskEditing).flags
            : <TaskFlag>[];

        return TaskFlag.values.map((flag) {
          final isSelected = selectedFlags.contains(flag);

          return PopupMenuItem<TaskFlag>(
            value: flag,
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check, color: colorScheme.onSecondary, size: 16),
                SizedBox(width: isSelected ? 8 : 0),
                Text(
                  flag.toString().split('.').last,
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
      icon: Icon(Icons.access_time, color: colorScheme.onSecondary),
      tooltip: 'Длительность',
      padding: EdgeInsets.zero,
      onSelected: (TaskDuration selectedDuration) {
        cubit.updateField(TaskField.duration, selectedDuration);
      },
      color: colorScheme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      constraints: BoxConstraints(maxWidth: 200),
      itemBuilder: (context) {
        final selectedDuration = (state is CreateTaskEditing)
            ? (state as CreateTaskEditing).duration
            : null;

        return TaskDuration.values.map((duration) {
          final isSelected = selectedDuration == duration;

          return PopupMenuItem<TaskDuration>(
            value: duration,
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check, color: colorScheme.onSecondary, size: 16),
                SizedBox(width: isSelected ? 8 : 0),
                Text(
                  duration.display,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(Icons.notifications_none, color: colorScheme.onSecondary),
      tooltip: 'Дата',
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: (state is CreateTaskEditing &&
                  (state as CreateTaskEditing).date != null)
              ? (state as CreateTaskEditing).date!
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          locale: const Locale('ru', 'RU'),

          // Настройка оформления DatePicker
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                // Основные цвета
                colorScheme: ColorScheme.light(
                  primary: colorScheme.secondary, // Цвет выбранной даты
                  onPrimary: Colors.white, // Цвет текста на выбранной дате
                  onSurface: colorScheme.surface, // Цвет текста календаря
                  surface: colorScheme.onBackground, // Цвет фона
                ),
                // Стиль диалогового окна
                dialogBackgroundColor: colorScheme.onBackground,

                // Настройка кнопок
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        colorScheme.secondary, // Цвет текста кнопок
                  ),
                ),
              ),
              child: Container(
                // Добавление скругления углов
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: child,
              ),
            );
          },
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 351,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colorScheme.surface.withOpacity(0.1),
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
