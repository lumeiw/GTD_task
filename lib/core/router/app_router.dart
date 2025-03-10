import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/folder/presentation/screens/next_screen.dart';
import 'package:gtd_task/features/task/presentation/screens/task_list_screen.dart';
import 'package:gtd_task/features/folder/presentation/screens/inbox_screen.dart';
import 'package:gtd_task/features/folder/presentation/screens/planned_screen.dart';
import 'package:gtd_task/features/folder/presentation/screens/waiting_screen.dart';
import 'package:gtd_task/features/folder/presentation/screens/someday_screen.dart';
import 'package:gtd_task/features/folder/presentation/screens/completed_screen.dart';

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
            path: '/next',
            builder: (context, state) => const NextScreen(),
          ),
          GoRoute(
            path: '/waiting',
            builder: (context, state) => const WaitingScreen(),
          ),
          GoRoute(
            path: '/planned',
            builder: (context, state) => const PlannedScreen(),
          ),
          GoRoute(
            path: '/someday',
            builder: (context, state) => const SomedayScreen(),
          ),
          GoRoute(
            path: '/completed',
            builder: (context, state) => const CompletedScreen(),
          ),
        ]
      )
    ]
  );
}