import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/task/presentation/screens/task_list_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/inbox_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/planned_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/waiting_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/someday_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/in_progress_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/completed_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/archive_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/projects_screen.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/task-list-screen',
    routes: [
      GoRoute(
        path: '/task-list-screen',
        builder: (context, state) => const TaskListScreen(),
        routes: [
          GoRoute(
            path: '/inbox',
            builder: (context, state) => const InboxScreen(),
          ),
          GoRoute(
            path: '/planned',
            builder: (context, state) => const PlannedScreen(),
          ),
          GoRoute(
            path: '/waiting',
            builder: (context, state) => const WaitingScreen(),
          ),
          GoRoute(
            path: '/someday',
            builder: (context, state) => const SomedayScreen(),
          ),
          GoRoute(
            path: '/in-progress',
            builder: (context, state) => const InProgressScreen(),
          ),
          GoRoute(
            path: '/completed',
            builder: (context, state) => const CompletedScreen(),
          ),
          GoRoute(
            path: '/archive',
            builder: (context, state) => const ArchiveScreen(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsScreen(),
          ),
        ]
      )
    ]
  );
}