import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
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
    
    final ScrollableState scrollable = Scrollable.of(itemKey.currentContext!);
    final itemPosition = itemBox.localToGlobal(Offset.zero, ancestor: scrollable.context.findRenderObject());
    final itemPositionScreen = itemBox.localToGlobal(Offset.zero);
    final itemSize = itemBox.size;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {

        final RenderBox overlay = Overlay.of(dialogContext).context.findRenderObject() as RenderBox;
        final localItemPosition = overlay.globalToLocal(itemPosition);

        return StatefulBuilder(
          builder: (context, setState) {
            // Получаем высоту клавиатуры
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final screenSize = MediaQuery.of(context).size;
            final isKeyboardVisible = keyboardHeight > 0;
            final isItemAtBottom = itemPositionScreen.dy > screenSize.height * 0.8;
            


            // Вычисляем позицию редактора
            double positionY;
            
            if (isItemAtBottom) {
            // Если задача в нижней половине экрана, размещаем редактор ВЫШЕ задачи
              positionY = localItemPosition.dy - itemSize.height; 
            } else {
            // Иначе размещаем НИЖЕ задачи
              positionY = localItemPosition.dy + itemSize.height * 1.6;
            }
            
            // Если клавиатура видима, корректируем позицию
            if (isKeyboardVisible) {
              final editorHeight = 230; 
              final editorBottom = positionY + editorHeight;
              final screenBottom = screenSize.height - keyboardHeight;
              
              // Если редактор перекрывается клавиатурой
              if (editorBottom > screenBottom) {
                // Двигаем редактор вверх
                positionY = screenBottom - editorHeight;
                positionY = positionY.clamp(20.0, screenSize.height - editorHeight);
              }
            }
            
            return Stack(
              children: [
                // Фон для закрытия по нажатию
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                
                // Редактор
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  top: positionY,
                  left: itemPosition.dx,
                  width: itemSize.width,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
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
                ),
              ],
            );
          },
        );
      },
    );
  }
}
