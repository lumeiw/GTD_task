import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/details/details_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/add_task_widget.dart';
import 'package:get_it/get_it.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _selectedTaskId;

  @override
  void initState() {
    super.initState();
    // Загружаем задачи при инициализации экрана
    context.read<TaskListCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.theme;
    // Получаем TaskListCubit из контекста
    final taskListCubit = context.read<TaskListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state is TaskListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskListLoaded) {
            final tasks = state.tasks;
            
            if (tasks.isEmpty) {
              return const Center(
                child: Text('Нет задач. Добавьте новую задачу!'),
              );
            }
            
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isSelected = task.id == _selectedTaskId;
                
                return Column(
                  children: [
                    // Отображаем задачу как заголовок и чекбокс
                    ListTile(
                      title: Text(task.title),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          // Используем TaskDetailsCubit для изменения статуса задачи
                          context.read<TaskDetailsCubit>().toggleComplete(task);
                          // Обновляем список задач
                          Future.delayed(const Duration(milliseconds: 300), () {
                            taskListCubit.loadTasks();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          if (_selectedTaskId == task.id) {
                            return;
                          }
                          _selectedTaskId = task.id;
                        });
                      },
                    ),
                    
                    // Если задача выбрана, показываем виджет редактирования
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          // Предотвращаем распространение событий касания
                          onTap: () {},
                          behavior: HitTestBehavior.opaque,
                          child: IgnorePointer(ignoring: false,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocProvider(
                                create: (context) => CreateTaskCubit(
                                  GetIt.I<ITaskRepository>(),
                                  GetIt.I<TaskFactory>(),
                                ),
                                child: AddTaskWidget(
                                  task: task,
                                  onTaskAdded: (updatedTask) {
                                    setState(() {
                                      _selectedTaskId = null;
                                    });
                                    taskListCubit.loadTasks();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),
                  ],
                );
              },
            );
          } else if (state is TaskListError) {
            return Center(
              child: Text('Ошибка: ${state.message}'),
            );
          }
          
          return const Center(child: Text('Загрузка задач...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Открываем модальное окно с формой добавления задачи
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: taskListCubit, // Передаем существующий TaskListCubit
                ),
                BlocProvider(
                  create: (context) => CreateTaskCubit(
                    GetIt.I<ITaskRepository>(),
                    GetIt.I<TaskFactory>(),
                  ),
                ),
              ],
              child: GestureDetector(
                // Предотвращаем закрытие модального окна при касании внутри него
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AddTaskWidget(
                          onTaskAdded: (task) {
                            // Закрываем модальное окно
                            Navigator.pop(context);
                            // Обновляем список задач
                            taskListCubit.loadTasks();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 