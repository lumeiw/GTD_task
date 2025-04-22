import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/folder/presentation/widgets/drawer_widget.dart';
import 'package:gtd_task/features/project/bloc/project_task/project_task_bloc.dart';
import 'package:gtd_task/features/project/bloc/project_task/project_task_state.dart';
import 'package:gtd_task/features/project/presentation/widget/project_app_bar.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/task_list_content.dart';
import 'package:gtd_task/features/task_action/domain/task_action_type_unem.dart';
import 'package:gtd_task/features/task_action/presentation/widget/expandable_action_button.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen(
      {super.key, required this.projectName, required this.projectId});

  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    context.read<ProjectTaskBloc>().loadTasksByProject(projectId);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: ProjectAppBar(projectName: projectName),
      drawer: const DrawerWidget(),
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ProjectTaskBloc, ProjectTaskState>(
        builder: (context, state) {
          return switch (state) {
            ProjectTaskInitial() => const SizedBox(),
            ProjectTaskLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProjectTaskError(message: var message) => Center(
                child: Text(
                  'Ошибка: $message',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ProjectTaskSuccess(tasks: var tasks) => TaskListContent(
                tasks: tasks,
              ),
          };
        },
      ),
      floatingActionButton: ExpandableActionButton(
        onActionSelected: (actionType) {
          switch (actionType) {
            case TaskActionType.createTask:
              showInlineTaskEditor(context, null, projectId);
              break;
            case TaskActionType.moveTask:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Будет реализовано позже'),
                ),
              );
              break;
            case TaskActionType.autoSort:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Будет реализовано позже'),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
