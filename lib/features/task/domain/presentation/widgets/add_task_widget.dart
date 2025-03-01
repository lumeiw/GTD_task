import 'package:flutter/material.dart';
import 'package:gtd_task/features/task/data/models/task_model.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';

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
        isCompleted: false,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            _addTask();
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 351,
                    child: Card(
                      shape: Theme.of(context).cardTheme.shape,
                      color: Theme.of(context).cardTheme.color,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Новая задача',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, напишите';
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 16),
                            ),
                            TextFormField(
                              controller: _bodyController,
                              decoration: const InputDecoration(
                                hintText: 'Описание задачи',
                                border: InputBorder.none,
                              ),
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 20),
                                  onPressed: () => _selectDate(context),
                                ),
                                PopupMenuButton<FolderType>(
                                  icon: const Icon(Icons.folder, size: 20),
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
                                PopupMenuButton<TaskDuration>(
                                  icon: const Icon(Icons.timer, size: 20),
                                  onSelected: (TaskDuration selectedDuration) {
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
                                PopupMenuButton<TaskFlag>(
                                  icon: const Icon(Icons.flag, size: 20),
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
                                      child:
                                          Text(flag.toString().split('.').last),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
