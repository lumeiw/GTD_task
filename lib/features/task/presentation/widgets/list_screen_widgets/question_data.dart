import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_field_enum.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/widgets/list_screen_widgets/autosort_widget.dart';


List<Question> getTaskQuestions(CreateTaskCubit cubit) {
  return [
    Question(
      text: 'Можно ли выполнить эту задачу прямо сейчас?',
      yesNextIndex: 1,
      noNextIndex: 2,
    ),
    Question(
      text: 'Важна ли задача прямо сейчас?',
      onAnswer: (isYes) {
        if (isYes) {
          cubit.updateField(TaskField.folder, FolderType.inProgress);
        }
      },
      yesNextIndex: null,
      noNextIndex: 3,
    ),
    Question(
      text: 'Нужно ли для этого действия некое условие?',
      onAnswer: (isYes) {
        if (isYes) {
          cubit.updateField(TaskField.folder, FolderType.waiting);
        }
      },
      yesNextIndex: null,
      noNextIndex: 3,
    ),
    Question(
      text: 'Выполнена ли задача на данный момент?',
      onAnswer: (isYes) {
        if (isYes) {
          cubit.updateField(TaskField.folder, FolderType.completed);
        }
      },
      yesNextIndex: null,
      noNextIndex: 4,
    ),
    Question(
      text: 'Есть ли у этой задачи конкретная дата/срок?',
      onAnswer: (isYes) {
        cubit.updateField(
          TaskField.folder,
          isYes ? FolderType.planned : FolderType.someday,
        );
      },
      yesNextIndex: null,
      noNextIndex: null,
    ),
  ];
}

