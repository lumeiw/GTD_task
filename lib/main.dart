import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/core/router/app_router.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';
import 'package:gtd_task/features/task_action/presentation/cubit/task_actions_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<TaskListCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CreateTaskCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<TaskActionsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<TaskActionsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final theme = switch (state) {
            ThemeLoaded state => state.themeData,
            _ => AppTheme.lightTheme,
          };

          return MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'GTD Task',
            theme: theme,
          );
        },
      ),
    );
  }
}
