import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/task/presentation/cubits/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(AppTheme.lightTheme));

  void toggleTheme() {
    emit(ThemeState(
      state.themeData == AppTheme.lightTheme
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
    ));
  }
}
