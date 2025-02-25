import 'package:flutter/material.dart';
import 'package:gtd_task/core/di/injection.dart';
import 'package:gtd_task/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}