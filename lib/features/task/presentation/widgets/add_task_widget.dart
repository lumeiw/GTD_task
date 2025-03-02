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
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';

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
  late DateTime? _date;
  late FolderType _folder;
  late final List<TaskFlag> _flags;
  late TaskDuration _duration;
  late String? _projectId;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    
    // Инициализируем контроллеры и переменные
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _bodyController = TextEditingController(text: widget.task?.body ?? '');
    _date = widget.task?.date;
    _folder = widget.task?.folder ?? FolderType.inbox;
    _flags = List<TaskFlag>.from(widget.task?.flags ?? []);
    _duration = widget.task?.duration ?? TaskDuration.undefined;
    _projectId = widget.task?.projectId;
    _isChecked = widget.task?.isCompleted ?? false;
    
    // Автоматическое сохранение при изменении текста
    _titleController.addListener(_autoSave);
    _bodyController.addListener(_autoSave);
  }
  
  @override
  void dispose() {
    _titleController.removeListener(_autoSave);
    _bodyController.removeListener(_autoSave);
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  
  void _autoSave() {
    // Если это новая задача, не сохраняем автоматически
    if (widget.task == null) return;
    
    // Если форма валидна, сохраняем изменения
    if (_formKey.currentState?.validate() ?? false) {
      _addTask();
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
      _autoSave(); // Автоматическое сохранение при изменении даты
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        // Создаем новую задачу
        context.read<CreateTaskCubit>().createTask(
              title: _titleController.text,
              body: _bodyController.text,
              folder: _folder,
              duration: _duration,
              date: _date,
              flags: _flags,
              projectId: _projectId,
            );
      } else {
        // Обновляем существующую задачу
        context.read<CreateTaskCubit>().updateTask(
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

      // Обновляем список задач после сохранения
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          context.read<TaskListCubit>().loadTasks();
        }
      });

      // Если это новая задача, сбрасываем форму
      if (widget.task == null) {
        setState(() {
          _titleController.clear();
          _bodyController.clear();
          _date = null;
          _folder = FolderType.inbox;
          _flags.clear();
          _duration = TaskDuration.undefined;
          _isChecked = false;
        });
      }
    }
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
                              _autoSave(); // Автоматическое сохранение при изменении статуса
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
                                _autoSave(); // Автоматическое сохранение при изменении папки
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
                                _autoSave(); // Автоматическое сохранение при изменении флагов
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
                                _autoSave(); // Автоматическое сохранение при изменении длительности
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