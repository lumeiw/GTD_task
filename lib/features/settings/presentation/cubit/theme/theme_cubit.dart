import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';
import 'package:gtd_task/features/task/domain/repositories/i_task_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final ITaskRepository _repository;

  ThemeCubit(this._repository) : super(ThemeState(AppTheme.lightTheme)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _repository.isDarkTheme();
    emit(ThemeState(isDark ? AppTheme.darkTheme : AppTheme.lightTheme));
  }

  void toggleTheme() async {
    final newTheme = state.themeData == AppTheme.lightTheme
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;

    emit(ThemeState(newTheme));
    await _repository.saveTheme(newTheme == AppTheme.darkTheme);
  }
}
