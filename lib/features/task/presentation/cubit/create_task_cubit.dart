import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/features/task/domain/entities/i_task_entity.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/factory/i_task_factory.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:gtd_task/features/task/presentation/cubit/create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskRepository _repository;
  final TaskFactory _factory;
  
  CreateTaskCubit(this._repository, this._factory) : super(CreateTaskInitial());

  Future<void> createTask(
    String id,
    String title,
    String body,
    FolderType folder,   //тут не уверен, что именно эти поля нужны (смотрел на i_task_entity)
    DateTime? date,
    List<TaskFlag> flags,
    TaskDuration duration,
    DateTime createdAt,
    bool isCompleted,
    String? projectId,
    ) async {
      try {
        emit(CreateTaskLoading());
        print('Создаем задачу: $id, $title'); //нужны ли вообще все эти принты?
        final task = _factory.createTask(
          //почему в фабрике нет поля id? (в i_task_factory)
          title: title,
          body: body,
          folder: FolderType.inbox,
          date: date,
          flags: [],
          duration: TaskDuration.undefined,
          isCompleted: false,
          projectId: null,
        );
        print('Задача создана через фабрику: $task');

        await _repository.createTask(task);
        print('Задача сохранена в репозиторий');

        emit(CreateTaskSuccess());
      } catch (e) {
        print('Ошибка при создании задачи: $e');
        emit(CreateTaskError(e.toString()));
      }
    }

  Future<void> updateTask(String taskId) async {
      try {
        emit(CreateTaskLoading());
        print('Обновляем задачу');

        await _repository.updateTask(task); //если тут не использовать фабрику, то как это исправить?
        print('Задача обновлена в репозиторий');
        emit(CreateTaskSuccess());
      } catch (e) {
        print('Ошибка при обновлении задачи: $e');
        emit(CreateTaskError(e.toString()));
      }
    }

  Future<void> deleteTask(String taskId) async {
    try {
      emit(CreateTaskLoading());
        
      await _repository.deleteTask(taskId);
      emit(CreateTaskSuccess());
    } catch (e) {
      print('Ошибка при удалении задачи: $e');
      emit(CreateTaskError(e.toString()));
    }
  }
}