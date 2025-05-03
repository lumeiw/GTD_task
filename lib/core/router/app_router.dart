import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/settings/presentation/screens/settings_screen.dart';
import 'package:gtd_task/features/project/presentation/project_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/task_list_screen.dart';
import 'package:gtd_task/features/task/domain/enums/folder_type_enum.dart';

abstract class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/task-list-screen/inbox',
    routes: [
      GoRoute(
        path: '/task-list-screen/:folderType',
        builder: (context, state) {
          final folderTypeString = state.pathParameters['folderType']!;
          final folderType = FolderType.values.firstWhere(
            (f) =>
                f.toString().split('.').last.toLowerCase() ==
                folderTypeString.toLowerCase(),
            orElse: () => FolderType.inbox,
          );
          return TaskListScreen(folderType: folderType);
        },
      ),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          final projectTitle = state.extra as String?;
          return ProjectScreen(
            projectName: projectTitle ?? 'Project $projectId',
            projectId: projectId,
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
