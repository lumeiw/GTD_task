import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';

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

        final editingState = state is CreateTaskEditing ? state : null;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: editingState?.title,
                  onChanged: createTaskCubit.updateTitle,
                  decoration: const InputDecoration(labelText: 'Заголовок'),
                ),
                TextFormField(
                  initialValue: editingState?.body,
                  onChanged: createTaskCubit.updateBody,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (task == null) {
                          createTaskCubit.saveNewTask();
                        } else {
                          createTaskCubit.saveExistingTask(task!);
                        }
                      },
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 