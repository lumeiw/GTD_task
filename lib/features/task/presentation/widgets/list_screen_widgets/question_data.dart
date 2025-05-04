import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/autosort_widget.dart';

List<Question> getTaskQuestions(CreateTaskCubit cubit) {
  return [
    // 1. Можно ли выполнить сейчас?
    Question(
      text: 'Можно ли выполнить эту задачу прямо сейчас?',
      yesNextIndex: 2, // Если да, проверяем важность
      noNextIndex: 1,  // Если нет, уточняем причину
    ),
    // 1.1. Почему нельзя выполнить сейчас?
    Question(
      text: 'Нужно ли для этого действие ждать условия (например, ответа или ресурса)?',
      yesText: 'Да, жду',
      noText: 'Нет, просто отложить',
      onAnswer: (isYes) {
        cubit.updateField(TaskField.folder, isYes ? FolderType.waiting : FolderType.someday);
      },
      yesNextIndex: null,
      noNextIndex: null,
    ),
    // 2. Важна ли задача прямо сейчас?
    Question(
      text: 'Важна ли эта задача прямо сейчас?',
      onAnswer: (isYes) {
        cubit.updateField(TaskField.folder, isYes ? FolderType.inProgress : FolderType.inbox);
      },
      yesNextIndex: null,
      noNextIndex: 3, // Если нет, проверяем выполнение
    ),
    // 3. Выполнена ли задача?
    Question(
      text: 'Выполнена ли эта задача на данный момент?',
      onAnswer: (isYes) {
        cubit.updateField(TaskField.folder, isYes ? FolderType.completed : FolderType.inbox);
      },
      yesNextIndex: null,
      noNextIndex: 4, // Если нет, проверяем дату
    ),
    // 4. Есть ли конкретная дата/срок?
    Question(
      text: 'Есть ли у этой задачи конкретная дата или срок?',
      onAnswer: (isYes) {
        cubit.updateField(TaskField.folder, isYes ? FolderType.planned : FolderType.someday);
      },
      yesNextIndex: null,
      noNextIndex: null,
    ),
  ];
}