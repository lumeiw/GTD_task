import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_state.dart';
import 'task_edit_card.dart';

class AnimatedTaskEditCard extends StatefulWidget {
  final ITaskEntity task;
  final VoidCallback onClose;

  const AnimatedTaskEditCard({
    required this.task,
    required this.onClose,
    super.key,
  });

  @override
  _AnimatedTaskEditCardState createState() => _AnimatedTaskEditCardState();
}

class _AnimatedTaskEditCardState extends State<AnimatedTaskEditCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: const Offset(10,
                0), //смещение вправо, отредактировать отступы по правилам, если надо
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: TaskEditCard(
                task: widget.task,
                onSaved: () {
                  final currentState = context.read<TaskListCubit>().state;
                  if (currentState is TaskListLoaded) {
                    context
                        .read<TaskListCubit>()
                        .loadTasksByFolder(currentState.folderType);
                  }
                  _controller.reverse().then((_) => widget.onClose());
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
