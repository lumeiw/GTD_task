import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/di/injection.dart';
// import 'package:gtd_task/core/storage/local_storage.dart';
import 'package:gtd_task/create_task_screen.dart';
import 'package:gtd_task/task_list_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // final localStorage = LocalStorage();
  // await localStorage.init();
  
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTD Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => getIt<TaskListCubit>(),
        child: const TaskListScreen(),
      ),
    );
  }
}