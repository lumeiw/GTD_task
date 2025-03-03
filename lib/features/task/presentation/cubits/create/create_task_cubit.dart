import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;  // Изменено с TaskFactory на ITaskFactory
  
  CreateTaskCubit(this._repository, this._factory) : super(CreateTaskInitial());

  // Вспомогательный метод для получения текущего состояния редактирования
  CreateTaskEditing _getEditingState() {
    if (state is CreateTaskEditing) {
      return state as CreateTaskEditing;
    }
    // Возвращаем новое состояние по умолчанию, если текущее не редактирование
    return CreateTaskEditing();
  }

  void updateTitle(String title) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(title: title));
  }

  void updateBody(String body) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(body: body));
  }

  void updateFolder(FolderType folder) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(folder: folder));
  }

  void updateFlags(List<TaskFlag> flags) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(flags: flags));
  }

  void updateDuration(TaskDuration duration) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(duration: duration));
  }

  void updateDate(DateTime? date) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(date: date));
  }

  void updateProjectId(String? projectId) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(projectId: projectId));
  }

  void updateIsCompleted(bool isCompleted) {
    final currentState = _getEditingState();
    emit(currentState.copyWith(isCompleted: isCompleted));
  }

  // Инициализация редактирования существующей задачи
  void initializeWithTask(ITaskEntity task) {
    emit(CreateTaskEditing(
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

  // Сброс состояния к редактированию после операций
  void resetToEditing() {
    if (state is! CreateTaskEditing) {
      final lastEditState = state is CreateTaskEditing 
          ? state as CreateTaskEditing 
          : CreateTaskEditing();
      emit(lastEditState);
    }
  }

  // Проверка валидности данных
  bool _validateData(CreateTaskEditing state) {
    //здесь нужные проверки, например:
    return state.title.isNotEmpty;
  }

  Future<void> saveNewTask() async {
    try {
      final editingState = _getEditingState();
      
      // Валидация данных
      if (!_validateData(editingState)) {
        emit(CreateTaskError("Необходимо заполнить все обязательные поля"));
        return;
      }
      
      emit(CreateTaskLoading());
      
      final task = _factory.createTask(
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
      
      // Валидация данных
      if (!_validateData(editingState)) {
        emit(CreateTaskError("Необходимо заполнить все обязательные поля"));
        return;
      }
      
      emit(CreateTaskLoading());
      
      final task = _factory.copyTask(
        existingTask,
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
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      emit(CreateTaskLoading());
      await _repository.deleteTask(id);
      emit(CreateTaskSuccess()); // Отсутствие task здесь корректно, так как задача удалена
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }
}