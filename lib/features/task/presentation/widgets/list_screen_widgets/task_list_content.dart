import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/project/bloc/project_task/project_task_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/autosort_widget.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/question_data.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/task_action_panel.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';

class TaskListContent extends StatelessWidget {
  final List<ITaskEntity> tasks;

  const TaskListContent({
    required this.tasks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskListItem(
          task: task,
          onTap: () => showInlineTaskEditor(context, task),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}

void showInlineTaskEditor(BuildContext context, [ITaskEntity? task, String? projectId]) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (_) => TaskEditorModal(task: task, projectId: projectId),
  );
}

void showAutoSortDialog(BuildContext context, ITaskEntity task) {
  final createTaskCubit = context.read<CreateTaskCubit>();
  final taskListCubit = context.read<TaskListCubit>();
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  createTaskCubit.initializeWithTask(task);

  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: QuestionCard(
        questions: getTaskQuestions(createTaskCubit),
        onCompleted: () async {
          await createTaskCubit.saveExistingTask(task);
          final cubitState = createTaskCubit.state;
          String folderName = 'неизвестно';
          if (cubitState is CreateTaskSuccess && cubitState.task != null) {
            final updatedTask = cubitState.task!;
            folderName = updatedTask.folder.text;
          }
          final currentState = taskListCubit.state;
          if (currentState is TaskListLoaded) {
            taskListCubit.loadTasksByFolder(currentState.folderType);
          }
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content:
                  Text('Задача "${task.title}" перемещена в "$folderName"'),
            ),
          );
          dialogContext.pop();
        },
      ),
    ),
  );
}

void showAutoSortSelection(BuildContext context) {
  final taskListCubit = context.read<TaskListCubit>();
  final state = taskListCubit.state;
  final colorScheme = Theme.of(context).colorScheme;

  if (state is TaskListLoaded) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите задачу для автосортировки',
                style: TextStyle(
                  color: colorScheme.surface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (state.tasks.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Нет задач для сортировки',
                      style: TextStyle(
                        color: colorScheme.surface,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        onTap: () {
                          dialogContext.pop();
                          showAutoSortDialog(context, task);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => dialogContext.pop(),
                child: Text(
                  'Отмена',
                  style: TextStyle(
                    color: colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskEditorModal extends StatelessWidget {
  const TaskEditorModal({super.key, this.task, this.projectId});

  final ITaskEntity? task;
  final String? projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CreateTaskCubit>(),
      child: _TaskEditorContent(task: task, projectId: projectId),
    );
  }
}

class _TaskEditorContent extends StatelessWidget {
  const _TaskEditorContent({this.task, this.projectId});

  final ITaskEntity? task;
  final String? projectId;

  @override
  Widget build(BuildContext context) {
    if (task == null && projectId != null) {
      context.read<CreateTaskCubit>().initialize(projectId: projectId);
    }

    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: _onStateChanged,
      child: _buildContent(),
    );
  }

  void _onStateChanged(BuildContext context, CreateTaskState state) {
    if (state is CreateTaskSuccess) {
      final currentState = context.read<TaskListCubit>().state;

      // Обновляем список задач по типу папки
      if (currentState is TaskListLoaded) {
        context
            .read<TaskListCubit>()
            .loadTasksByFolder(currentState.folderType);
      }

      if (projectId != null) {
        try {
          context.read<ProjectTaskBloc>().loadTasksByProject(projectId!);
        } catch (e) {
          log('ProjectTaskBloc не доступен: $e');
        }
      }

      context.pop();
    }
  }

  Widget _buildContent() {
    return StatefulBuilder(builder: (context, setState) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final isKeyboardVisible = keyboardHeight > 0;

      final initialSize = 0.4;

      return Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: DraggableScrollableSheet(
          initialChildSize: initialSize,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  //* 1. Полоска для перетаскивания
                  Container(
                    width: 40,
                    height: 6,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: LightAppColors.cartColor4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  //* 2. Основной контент (форма редактирования)
                  Expanded(
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: scrollController,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              16, 16, 16, isKeyboardVisible ? 20 : 16),
                          child: TaskEditCard(
                            task: task,
                            projectId: projectId,
                            onSaved: () => context.pop(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //* 3. Панель действий (если есть задача)
                  if (!isKeyboardVisible && task != null)
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: TaskActionsPanel(
                          task: task!,
                          onTaskDeletedOrMove: () => context.pop(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
