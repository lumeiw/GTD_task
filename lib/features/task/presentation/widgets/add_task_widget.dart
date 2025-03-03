import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'dart:async';

import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';

class AddTaskWidget extends StatefulWidget {
  final ITaskEntity? task;
  final Function(ITaskEntity)? onTaskAdded;

  const AddTaskWidget({super.key, this.task, this.onTaskAdded});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  
  // UI состояние
  DateTime? _date;
  late FolderType _folder;
  late List<TaskFlag> _flags;
  late TaskDuration _duration;
  String? _projectId;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    // Инициализируем значения из существующей задачи
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _bodyController = TextEditingController(text: task?.body ?? '');
    _date = task?.date;
    _folder = task?.folder ?? FolderType.inbox;
    _flags = List<TaskFlag>.from(task?.flags ?? []);
    _duration = task?.duration ?? TaskDuration.undefined;
    _projectId = task?.projectId;
    _isChecked = task?.isCompleted ?? false;
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    
    final createTaskCubit = context.read<CreateTaskCubit>();
    
    if (widget.task == null) {
      createTaskCubit.createTask(
        title: _titleController.text,
        body: _bodyController.text,
        folder: _folder,
        duration: _duration,
        date: _date,
        flags: _flags,
        projectId: _projectId,
      );
    } else {
      createTaskCubit.updateTask(
        widget.task!,
        title: _titleController.text,
        body: _bodyController.text,
        folder: _folder,
        duration: _duration,
        date: _date,
        flags: _flags,
        projectId: _projectId,
        isCompleted: _isChecked,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.theme;
    final colorScheme = theme.colorScheme;

    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess && widget.onTaskAdded != null && state.task != null) {
          widget.onTaskAdded!(state.task!);
        }
      },
      child: Form(
        key: _formKey,
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
                onTap: () {
                  // Обработка нажатия на карточку
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: colorScheme.onSurface,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: _isChecked
                                    ? colorScheme.primary
                                    : Colors.transparent,
                              ),
                              child: _isChecked 
                                ? Icon(Icons.check, size: 12, color: colorScheme.onPrimary)
                                : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Новая задача',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                contentPadding: const EdgeInsets.only(top: 8.0),
                              ),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: SizedBox(
                          height: 30,
                          child: TextFormField(
                            controller: _bodyController,
                            decoration: InputDecoration(
                              hintText: 'Заметки',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLines: 2,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton<FolderType>(
                              icon: Icon(Icons.folder_open, color: LightAppColors.iconColor),
                              padding: EdgeInsets.zero,
                              onSelected: (FolderType selectedFolder) {
                                setState(() {
                                  _folder = selectedFolder;
                                });
                              },
                              color: colorScheme.surface,
                              itemBuilder: (context) =>
                                  FolderType.values.map((folder) {
                                return PopupMenuItem(
                                  value: folder,
                                  child: Text(
                                    folder.toString().split('.').last,
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                );
                              }).toList(),
                            ),
                            PopupMenuButton<TaskFlag>(
                              icon: Icon(Icons.bookmark_border, color: LightAppColors.iconColor),
                              padding: EdgeInsets.zero,
                              onSelected: (TaskFlag selectedFlag) {
                                setState(() {
                                  if (_flags.contains(selectedFlag)) {
                                    _flags.remove(selectedFlag);
                                  } else {
                                    _flags.add(selectedFlag);
                                  }
                                });
                              },
                              color: colorScheme.surface,
                              itemBuilder: (context) =>
                                  TaskFlag.values.map((flag) {
                                return PopupMenuItem(
                                  value: flag,
                                  child: Text(
                                    flag.toString().split('.').last,
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                );
                              }).toList(),
                            ),
                            PopupMenuButton<TaskDuration>(
                              icon: Icon(Icons.access_time, color: LightAppColors.iconColor),
                              padding: EdgeInsets.zero,
                              onSelected: (TaskDuration selectedDuration) {
                                setState(() {
                                  _duration = selectedDuration;
                                });
                              },
                              color: colorScheme.surface,
                              itemBuilder: (context) =>
                                  TaskDuration.values.map((duration) {
                                return PopupMenuItem(
                                  value: duration,
                                  child: Text(
                                    duration.display,
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                );
                              }).toList(),
                            ),
                            IconButton(
                              icon: Icon(Icons.notifications_none, color: LightAppColors.iconColor),
                              padding: EdgeInsets.zero,
                              onPressed: () => _selectDate(context),
                              constraints: const BoxConstraints(
                                minWidth: 36, 
                                minHeight: 36
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _saveTask,
                        child: Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}