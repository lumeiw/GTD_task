import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/services/notification_helper.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;

  CreateTaskCubit(this._repository, this._factory) : super(CreateTaskInitial());

  CreateTaskEditing _getEditingState() {
    if (state is CreateTaskEditing) {
      return state as CreateTaskEditing;
    }
    return CreateTaskEditing();
  }

  void updateField<T>(TaskField field, T value) async {
    final currentState = _getEditingState();

    final updatedState = currentState.copyWith(
      id: currentState.id,
      title: field == TaskField.title ? value as String : currentState.title,
      body: field == TaskField.body ? value as String : currentState.body,
      folder:
          field == TaskField.folder ? value as FolderType : currentState.folder,
      flags: field == TaskField.flags
          ? value as List<TaskFlag>
          : currentState.flags,
      duration: field == TaskField.duration
          ? value as TaskDuration
          : currentState.duration,
      date: field == TaskField.date ? value as DateTime? : currentState.date,
      projectId: field == TaskField.projectId
          ? value as String?
          : currentState.projectId,
      isCompleted: field == TaskField.isCompleted
          ? value as bool
          : currentState.isCompleted,
    );

    emit(updatedState);

    if (field == TaskField.date && updatedState.date != null) {
      await _scheduleNotificationIfNeeded(updatedState);
    }
  }

  void initializeWithTask(ITaskEntity task) {
    emit(CreateTaskEditing(
      id: task.id,
      title: task.title,
      body: task.body,
      folder: task.folder,
      flags: task.flags,
      duration: task.duration,
      date: task.date,
      projectId: task.projectId,
      isCompleted: task.isCompleted,
    ));
  }

  void initialize({String? projectId}) {
    emit(CreateTaskEditing(projectId: projectId));
  }

  void resetToEditing() {
    if (state is! CreateTaskEditing) {
      final lastEditState = state is CreateTaskEditing
          ? state as CreateTaskEditing
          : CreateTaskEditing();
      emit(lastEditState);
    }
  }

  Future<void> saveNewTask() async {
    try {
      final editingState = _getEditingState();
      emit(CreateTaskLoading());

      final task = _factory.createTask(
        id: editingState.id,
        title: editingState.title,
        body: editingState.body,
        folder: editingState.folder,
        duration: editingState.duration,
        date: editingState.date,
        flags: editingState.flags,
        projectId: editingState.projectId,
      );
      await _repository.createTask(task);
      emit(CreateTaskSuccess(task));
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> saveExistingTask(ITaskEntity existingTask) async {
    try {
      final editingState = _getEditingState();
      emit(CreateTaskLoading());

      final task = _factory.copyTask(
        existingTask,
        id: editingState.id,
        title: editingState.title,
        body: editingState.body,
        folder: editingState.folder,
        duration: editingState.duration,
        date: editingState.date,
        flags: editingState.flags,
        projectId: editingState.projectId,
        isCompleted: editingState.isCompleted,
      );

      await _repository.updateTask(task);
      emit(CreateTaskSuccess(task));
      await _scheduleNotificationIfNeeded(editingState);
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      emit(CreateTaskLoading());

      final id32 = id % 2147483647;
      final notificationService = NotificationService();
      await notificationService.initNotification();
      await notificationService.cancelTaskNotifications(id32, -id32);

      await _repository.deleteTask(id);
      emit(CreateTaskSuccess());
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> _scheduleNotificationIfNeeded(CreateTaskEditing state) async {
    final date = state.date;
    final title = state.title;
    final id = state.id;

    if (date == null || state.isCompleted) return;

    final notificationService = NotificationService();
    await notificationService.initNotification();

    final id32 = id % 2147483647;
    final idMorning = id32;
    final idEvening = -id32;

    // Отменяем старые уведомления с этими ID перед созданием новых
    await notificationService.cancelTaskNotifications(idMorning, idEvening);

    print("⚙️ Перед вызовом zonedSchedule: ID=$idMorning");

    await notificationService.scheduleMorningAndEveningNotification(
      idMorning: idMorning,
      idEvening: idEvening,
      title: 'Задача $title',
      body: 'Не забудьте выполнить задачу!',
      taskDate: date,
    );

    print("Уведомления установлены на $date для задачи с ID $id");
  }
}
