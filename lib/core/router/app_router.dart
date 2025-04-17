import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/project/presentation/project_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/task_list_screen.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/task-list-screen',
    routes: [
      GoRoute(
        path: '/task-list-screen',
        builder: (context, state) =>
            const TaskListScreen(folderType: FolderType.inbox),
      ),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          final projectTitle = state.extra as String?;
          return ProjectScreen(projectName: projectTitle ?? 'Project $projectId');
        },
      ),
    ],
  );
}