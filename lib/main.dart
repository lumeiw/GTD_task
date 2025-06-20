import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/core/router/app_router.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/project/bloc/create/project_create_bloc.dart';
import 'package:gtd_task/features/project/bloc/list/project_list_bloc.dart';
import 'package:gtd_task/features/project/bloc/project_task/project_task_bloc.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';
import 'package:gtd_task/features/task_action/presentation/cubit/task_actions_cubit.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'core/services/notification_helper.dart';

final notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().initNotification();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
          create: (context) => getIt<CreateProjectBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProjectListBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProjectTaskBloc>(),
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
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('ru', 'RU'),
          );
        },
      ),
    );
  }
}
