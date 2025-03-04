import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';

class TaskEditCard extends StatefulWidget {
  final ITaskEntity? task;
  final VoidCallback onSaved;

  const TaskEditCard({
    this.task,
    required this.onSaved,
    super.key,
  });

  @override
  _TaskEditCardState createState() => _TaskEditCardState();
}

class _TaskEditCardState extends State<TaskEditCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  DateTime? _date;
  late FolderType _folder;
  late List<TaskFlag> _flags;
  late TaskDuration _duration;
  String? _projectId;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
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

  void _updateTaskDataInCubit(CreateTaskCubit cubit) {
    cubit.updateTitle(_titleController.text);
    cubit.updateBody(_bodyController.text);
    cubit.updateDate(_date);
    cubit.updateFolder(_folder);
    cubit.updateFlags(_flags);
    cubit.updateDuration(_duration);
    cubit.updateProjectId(_projectId);
    cubit.updateIsCompleted(_isChecked);
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final createTaskCubit = context.read<CreateTaskCubit>();
      
      _updateTaskDataInCubit(createTaskCubit);
      
      if (widget.task == null) {
        createTaskCubit.saveNewTask();
      } else {
        createTaskCubit.saveExistingTask(widget.task!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.theme;
    final colorScheme = theme.colorScheme;
    final createTaskCubit = context.read<CreateTaskCubit>();

    if (widget.task != null) {
      createTaskCubit.initializeWithTask(widget.task!);
    }

    return BlocConsumer<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          widget.onSaved();
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

        return Form(
          key: _formKey,
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
                    onTap: () { 
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                  width: 20, 
                                  height: 20, 
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.5, 
                                      color: colorScheme.onSurface,
                                    ),
                                    borderRadius: BorderRadius.circular(4), 
                                    color: _isChecked
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                  child: _isChecked
                                      ? Icon(Icons.check,
                                          size: 10, 
                                          color: colorScheme.onPrimary)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: TextFormField(
                                    controller: _titleController,
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
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 36.0, top: 3.0), 
                      
                            child: TextFormField(
                              controller: _bodyController,
                              decoration: InputDecoration(
                                hintText: 'Заметки',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                          
                              maxLines: null,
                           
                              minLines: 1,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                         
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: _saveTask,
                                      icon: Icon(
                                        Icons.save,
                                        color: LightAppColors.iconColor, 
                                      ),
                                      tooltip: 'Сохранить',
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 32, 
                                        minHeight: 32
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    PopupMenuButton<FolderType>(
                                      icon: Icon(Icons.folder_open,
                                          color: LightAppColors.iconColor),
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
                                            style: TextStyle(
                                                color: colorScheme.onSurface),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    PopupMenuButton<TaskFlag>(
                                      icon: Icon(Icons.bookmark_border,
                                          color: LightAppColors.iconColor),
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
                                            style: TextStyle(
                                                color: colorScheme.onSurface),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    PopupMenuButton<TaskDuration>(
                                      icon: Icon(Icons.access_time,
                                          color: LightAppColors.iconColor),
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
                                            style: TextStyle(
                                                color: colorScheme.onSurface),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.notifications_none,
                                          color: LightAppColors.iconColor),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _selectDate(context),
                                      constraints: const BoxConstraints(
                                          minWidth: 32, minHeight: 32),
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
        );
      },
    );
  }
}
