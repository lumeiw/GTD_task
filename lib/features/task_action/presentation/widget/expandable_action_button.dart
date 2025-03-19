import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task_action/domain/task_action_type_unem.dart';
import 'package:gtd_task/features/task_action/presentation/cubit/task_actions_cubit.dart';
import 'package:gtd_task/features/task_action/presentation/cubit/task_actions_state.dart';

class ExpandableActionButton extends StatelessWidget {
  final Function(TaskActionType) onActionSelected;

  const ExpandableActionButton({
    required this.onActionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskActionsCubit, TaskActionsState>(
      builder: (context, state) {
        return SizedBox(
          height: 320,
          width: 200,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildActionButton(
                progress: state.expandProgress,
                position: 160,
                icon: Icons.add_task,
                onTap: () => onActionSelected(TaskActionType.createTask),
              ),
              _buildActionButton(
                progress: state.expandProgress,
                position: 110,
                icon: Icons.folder_copy,
                onTap: () => onActionSelected(TaskActionType.moveTask),
              ),
              _buildActionButton(
                progress: state.expandProgress,
                position: 60,
                icon: Icons.sort,
                onTap: () => onActionSelected(TaskActionType.autoSort),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                
                child: FloatingActionButton(
                  onPressed: () => context.read<TaskActionsCubit>().toggleActionButtons(),
                  backgroundColor: LightAppColors.cartColor3,
                  child: Transform.rotate(
                    angle: state.expandProgress * 0.785398,
                    child: Icon(Icons.add, color: LightAppColors.cartColor6),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required double progress,
    required double position,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Positioned(
      right: 0,
      bottom: position * progress,
      child: Opacity(
        opacity: progress,
        child: Row(
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: FloatingActionButton.small(
                onPressed: onTap,
                backgroundColor: LightAppColors.cartColor6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: LightAppColors.cartColor3,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
