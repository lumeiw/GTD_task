import 'dart:async';

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
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final isDark = currentState.themeData == AppTheme.lightTheme;
      final newTheme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
      
      //* Сначала обновляем UI
      emit(ThemeLoaded(newTheme));
      
      //* Затем сохраняем в фоне
      unawaited(_repository.saveTheme(isDark));
    }
  }
}
