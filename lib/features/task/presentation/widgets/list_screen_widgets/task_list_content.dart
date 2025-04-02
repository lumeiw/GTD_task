import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/task_action_panel.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_edit_card.dart';
import 'package:gtd_task/features/task/presentation/widgets/task_list_item.dart';

class TaskListContent extends StatelessWidget {
  final List<ITaskEntity> tasks;

  const TaskListContent({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final itemKey = GlobalKey();
        
        return TaskListItem(
          key: itemKey,
          task: task, 
          onTap: () => _showInlineTaskEditor(context, task, itemKey),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }


  void _showInlineTaskEditor(BuildContext context, ITaskEntity task, GlobalKey itemKey) {
    // Находим RenderBox с помощью ключа
    final RenderBox? itemBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (itemBox == null) return; // Защита от ошибок
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final isKeyboardVisible = keyboardHeight > 0;
            
            final initialSize = isKeyboardVisible ? 0.4 : 0.4;
            
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
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        
                        Expanded(
                          child: ListView(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            controller: scrollController,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, isKeyboardVisible ? 20 : 16),
                                child: BlocProvider.value(
                                  value: getIt<CreateTaskCubit>(),
                                  child: TaskEditCard(
                                    task: task,
                                    onSaved: () {
                                      context.pop();
                                      final currentState = context.read<TaskListCubit>().state;
                                      if (currentState is TaskListLoaded) {
                                        context.read<TaskListCubit>().loadTasksByFolder(currentState.folderType);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        if (!isKeyboardVisible)
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: TaskActionsPanel(
                                task: task,
                                onTaskDeletedOrMove: () {
                                  context.pop();
                                  final currentState = context.read<TaskListCubit>().state;
                                  if (currentState is TaskListLoaded) {
                                    context.read<TaskListCubit>().loadTasksByFolder(currentState.folderType);
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
