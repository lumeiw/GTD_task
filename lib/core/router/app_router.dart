import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/folder/presentation/screens/settings_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/task_list_screen.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';

abstract class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: '/task-list-screen', routes: [
    GoRoute(
      path: '/task-list-screen',
      builder: (context, state) =>
          const TaskListScreen(folderType: FolderType.inbox),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ]);
}
