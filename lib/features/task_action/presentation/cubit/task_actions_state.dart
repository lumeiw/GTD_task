sealed class TaskActionsState {
  final double expandProgress;
  
  const TaskActionsState({required this.expandProgress});
}

class TaskActionsInitial extends TaskActionsState {
  const TaskActionsInitial() : super(expandProgress: 0.0);
}

class TaskActionsExpanded extends TaskActionsState {
  const TaskActionsExpanded() : super(expandProgress: 1.0);
}

class TaskActionsCollapsed extends TaskActionsState {
  const TaskActionsCollapsed() : super(expandProgress: 0.0);
}

class TaskActionsAnimating extends TaskActionsState {
  const TaskActionsAnimating({required super.expandProgress});
}