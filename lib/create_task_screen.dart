import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/create_task_cubit.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/task_list_cubit.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем задачи при инициализации
    context.read<TaskListCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TaskListCubit>().refresh();
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state is TaskListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TaskListError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          
          if (state is TaskListLoaded) {
            final tasks = state.tasks;
            
            if (tasks.isEmpty) {
              return const Center(child: Text('Нет задач'));
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<TaskListCubit>().refresh();
              },
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.body),
                    trailing: Text(task.duration.displayName),
                  );
                },
              ),
            );
          }
          
          return const Center(child: Text('Загрузка задач...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<TaskListCubit>(),
          ),
          BlocProvider(
            create: (_) => getIt<CreateTaskCubit>(),
          ),
        ],
        child: BlocListener<CreateTaskCubit, CreateTaskState>(
          listener: (listenerContext, state) {
            if (state is CreateTaskSuccess) {
              Navigator.of(dialogContext).pop();
              context.read<TaskListCubit>().refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Задача создана')),
              );
            } else if (state is CreateTaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: ${state.message}')),
              );
            }
          },
          child: const CreateTaskDialog(),
        ),
      ),
    );
  }
}

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  TaskDuration _selectedDuration = TaskDuration.undefined;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskDuration>(
              value: _selectedDuration,
              decoration: const InputDecoration(
                labelText: 'Длительность',
                border: OutlineInputBorder(),
              ),
              items: TaskDuration.values.map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text(duration.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDuration = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      final cubit = context.read<CreateTaskCubit>();
                      cubit.createTask(
                        _titleController.text,
                        _bodyController.text,
                        _selectedDuration,
                      );
                      context.read<TaskListCubit>().refresh();
                    }
                  },
                  child: const Text('Создать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}