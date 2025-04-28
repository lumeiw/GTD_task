import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/settings/domain/repository/theme_repository.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _repository;

  ThemeCubit(this._repository) : super(ThemeInitial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      emit(ThemeLoading());

      final isDark = await _repository.isDarkTheme();
      emit(ThemeLoaded(isDark ? AppTheme.darkTheme : AppTheme.lightTheme));
    } catch (e) {
      emit(ThemeError(e.toString()));
    }
  }

  Future<void> toggleTheme() async {
    final currentTheme = switch (state) {
      ThemeLoaded(themeData: var theme) => theme,
      _ => AppTheme.lightTheme,
    };

    try {
      final newIsDark = currentTheme == AppTheme.lightTheme;
      final newTheme = newIsDark ? AppTheme.darkTheme : AppTheme.lightTheme;

      emit(ThemeLoaded(newTheme));
      await _repository.saveTheme(newIsDark);
    } catch (e) {
      emit(ThemeError(e.toString()));
    }
  }
}
