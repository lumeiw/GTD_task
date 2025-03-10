import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';
import 'package:gtd_task/features/folder/presentation/widgets/drawer_widget.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        leading: Builder(
          builder: (innerContext) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(innerContext).openDrawer();
            },
          ),
        ),
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          return switch (state) {
            TaskListInitial() => const SizedBox(),
            TaskListLoading() => const Center(child: CircularProgressIndicator()),
            TaskListError(message: var message) => Center(child: Text('Ошибка: $message')),
            TaskListLoaded(tasks: var tasks) => ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListItem(
                  task: task,
                  onTap: () => _showEditTask(context, task),
                );
              },
            ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditTask(BuildContext context, [ITaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => GetIt.I<CreateTaskCubit>(),
        child: TaskEditCard(
          task: task,
          onSaved: () {
            Navigator.pop(context);
            context.read<TaskListCubit>().loadTasks();
          },
        ),
      ),
    );
  }
}