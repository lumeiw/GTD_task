import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task_action/presentation/cubit/task_actions_state.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

@injectable
class TaskActionsCubit extends Cubit<TaskActionsState> {
  Timer? _animationTimer;
  static const _animationDuration = Duration(milliseconds: 200); // уменьшим время для более быстрой анимации
  static const _animationSteps = 20;

  TaskActionsCubit() : super(const TaskActionsInitial());

  @override
  Future<void> close() {
    _animationTimer?.cancel();
    return super.close();
  }

  void toggleActionButtons() {
    if (state is TaskActionsExpanded) {
      _animateProgress(1.0, 0.0);
    } else {
      _animateProgress(0.0, 1.0);
    }
  }

  void _animateProgress(double from, double to) {
    _animationTimer?.cancel();
    
    final stepValue = (to - from) / _animationSteps;
    var currentProgress = from;
    final stepDuration = _animationDuration.inMilliseconds ~/ _animationSteps;

    // Сразу устанавливаем позиции кнопок
    if (to > from) {
      emit(TaskActionsAnimating(expandProgress: 0.0));
    }

    _animationTimer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      currentProgress += stepValue;
      
      if ((stepValue > 0 && currentProgress >= to) || 
          (stepValue < 0 && currentProgress <= to)) {
        timer.cancel();
        currentProgress = to;
      }

      // Теперь анимируем только прозрачность
      if (currentProgress >= 1.0) {
        emit(const TaskActionsExpanded());
      } else if (currentProgress <= 0.0) {
        emit(const TaskActionsCollapsed());
      } else {
        emit(TaskActionsAnimating(expandProgress: currentProgress));
      }
    });
  }
}