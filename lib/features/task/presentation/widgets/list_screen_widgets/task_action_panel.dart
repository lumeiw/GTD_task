import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';

class TaskActionsPanel extends StatelessWidget {
  final ITaskEntity task;
  final VoidCallback onTaskDeletedOrMove;

  const TaskActionsPanel({
    required this.task,
    required this.onTaskDeletedOrMove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          final currentState = context.read<TaskListCubit>().state;
          if (currentState is TaskListLoaded) {
            context.read<TaskListCubit>().loadTasksByFolder(currentState.folderType);
          }
        }
      },
      child: Container(
        height: 56,
        width: 130,
        //MediaQuery.of(context).size.width * 0.3}
        
        decoration: BoxDecoration(
          color: LightAppColors.cartColor2,
          borderRadius: BorderRadius.circular(24), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Кнопка перемещения задачи
              _buildActionButton(
                context: context,
                icon: Icons.east,
                label: '',
                color: LightAppColors.cartColor4,
                onTap: () => _showMoveTaskDialog(context),
              ),
              
              // Разделитель
              Container(
                height: 24,
                width: 1,
                color: LightAppColors.cartColor4.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              
              // Кнопка удаления задачи
              _buildActionButton(
                context: context,
                icon: Icons.delete_outline,
                label: '',
                color: LightAppColors.cartColor4,
                onTap: () => _confirmDeleteTask(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context) {
    final parentContext = context;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
            primary: colorScheme.secondary, 
            onPrimary: Colors.white, 
            onSurface: colorScheme.surface, 
            surface: colorScheme.onBackground,
          ),
  
          dialogBackgroundColor: colorScheme.primary,
          
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.surface, // Цвет текста кнопок
            ),
          ),
 
          listTileTheme: ListTileThemeData(
            textColor: colorScheme.onSurface,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Удалить задачу', style: TextStyle(color: colorScheme.onSurface)),
          content: Text('Вы уверены, что хотите удалить эту задачу?', style: TextStyle(color: colorScheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                parentContext.pop(); 
                final createTaskCubit = parentContext.read<CreateTaskCubit>();
                createTaskCubit.deleteTask(task.id); // Удаляем задачу
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
                textStyle: TextStyle(fontWeight: FontWeight.bold)
              ),
              child: Text('Удалить'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveTaskDialog(BuildContext context) {
    final parentContext = context;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: colorScheme.secondary, 
            onPrimary: Colors.white, 
            onSurface: colorScheme.surface, 
            surface: colorScheme.onBackground,
          ),
  
          dialogBackgroundColor: colorScheme.primary,
          
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.surface, // Цвет текста кнопок
            ),
          ),
 
          listTileTheme: ListTileThemeData(
            textColor: colorScheme.onSurface,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text('Переместить задачу', style: TextStyle(color: colorScheme.onSurface)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: FolderType.values.length,
              itemBuilder: (_, index) {
                final folder = FolderType.values[index];
                return ListTile(
                  title: Text(folder.text),
                  onTap: () { 
                    parentContext.pop(); 
                    
                    final createTaskCubit = parentContext.read<CreateTaskCubit>();
                    createTaskCubit.initializeWithTask(task);
                    createTaskCubit.updateField(TaskField.folder, folder);
                    createTaskCubit.saveExistingTask(task);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text('Отмена'),
            ),
          ],
        ),
      ),
    );
  }
}