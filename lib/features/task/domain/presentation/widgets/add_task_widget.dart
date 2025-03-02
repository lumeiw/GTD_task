import 'package:flutter/material.dart';
import 'package:gtd_task/features/task/data/models/task_model.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'dart:async';

class AddTaskWidget extends StatefulWidget {
  final Function(TaskModel) onTaskAdded;

  const AddTaskWidget({super.key, required this.onTaskAdded});

  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? _date;
  FolderType _folder = FolderType.inbox;
  final List<TaskFlag> _flags = [];
  TaskDuration _duration = TaskDuration.undefined;
  String? _projectId;
  bool _isHidden = false;
  bool _isChecked = false;

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

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        body: _bodyController.text,
        folder: _folder,
        date: _date,
        flags: _flags,
        duration: _duration,
        createdAt: DateTime.now(),
        isCompleted: _isChecked,
        projectId: _projectId,
      );
      widget.onTaskAdded(task);

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

  @override
  Widget build(BuildContext context) {
    if (_isHidden) return SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: _addTask,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 351,
                    height: 136, 
                    child: Card(
                      shape: AppTheme.theme.cardTheme.shape,
                      color: AppTheme.theme.cardTheme.color,
                      elevation: AppTheme.theme.cardTheme.elevation,
                      shadowColor: AppTheme.theme.cardTheme.shadowColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                    margin: const EdgeInsets.only(top: 8.0, left: 8.0),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _isChecked
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSecondary
                                          : Colors.transparent,
                                    ),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      contentPadding: const EdgeInsets.only(top: 8.0),
                                    ),
                                    
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                     
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Container(
                                height: 30,
                                child: TextFormField(
                                  controller: _bodyController,
                                  decoration: InputDecoration(
                                    hintText: 'Заметки',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0, top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  
                                  PopupMenuButton<FolderType>(
                                    icon: const Icon(Icons.folder_open),
                                    padding: EdgeInsets.zero,
                                    onSelected: (FolderType selectedFolder) {
                                      setState(() {
                                        _folder = selectedFolder;
                                      });
                                    },
                                    color: Theme.of(context).primaryColor,
                                    itemBuilder: (context) =>
                                        FolderType.values.map((folder) {
                                      return PopupMenuItem(
                                        value: folder,
                                        child: Text(
                                            folder.toString().split('.').last),
                                      );
                                    }).toList(),
                                  ),
                                  PopupMenuButton<TaskFlag>(
                                    icon: const Icon(Icons.bookmark_border),
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
                                    color: Theme.of(context).primaryColor,
                                    itemBuilder: (context) =>
                                        TaskFlag.values.map((flag) {
                                      return PopupMenuItem(
                                        value: flag,
                                        child: Text(
                                            flag.toString().split('.').last),
                                      );
                                    }).toList(),
                                  ),
                                  PopupMenuButton<TaskDuration>(
                                    icon: const Icon(Icons.access_time),
                                    padding: EdgeInsets.zero,
                                    onSelected:
                                        (TaskDuration selectedDuration) {
                                      setState(() {
                                        _duration = selectedDuration;
                                      });
                                    },
                                    color: Theme.of(context).primaryColor,
                                    itemBuilder: (context) =>
                                        TaskDuration.values.map((duration) {
                                      return PopupMenuItem(
                                        value: duration,
                                        child: Text(duration.display),
                                      );
                                    }).toList(),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.notifications_none),
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _selectDate(context),
                                    constraints: BoxConstraints(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}