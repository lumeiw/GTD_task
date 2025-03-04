import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Меню',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Входящие'),
              onTap: () {
                context.go('/task-list-screen/inbox');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('В планах'),
              onTap: () {
                context.go('/task-list-screen/planned');
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('Ожидание'),
              onTap: () {
                context.go('/task-list-screen/waiting');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Когда-нибудь'),
              onTap: () {
                context.go('/task-list-screen/someday');
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('В работе'),
              onTap: () {
                context.go('/task-list-screen/in-progress');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Завершенные'),
              onTap: () {
                context.go('/task-list-screen/completed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Архив'),
              onTap: () {
                context.go('/task-list-screen/archive');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_special),
              title: const Text('Проекты'),
              onTap: () {
                context.go('/task-list-screen/projects');
              },
            ),
          ],
        ),
      ),
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
            // Обновляем список задач после сохранения
            context.read<TaskListCubit>().loadTasks();
          },
        ),
      ),
    );
  }
}