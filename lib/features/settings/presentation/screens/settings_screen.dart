import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text('Настройки'),
      ),
      body: Container(
        color: colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Тема',
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      final isDarkTheme = switch (themeState) {
                        ThemeLoaded state => state.themeData == AppTheme.darkTheme,
                        _ => false,
                      };
                      
                      // Кэшируем цвета для переключателя
                      final activeColor = isDarkTheme ? colorScheme.secondary : colorScheme.primary;
                      final inactiveThumbColor = isDarkTheme ? colorScheme.onSurface : colorScheme.onSecondary;
                      final inactiveTrackColor = isDarkTheme ? colorScheme.onSecondary : colorScheme.primary;
                          
                      return Switch(
                        value: isDarkTheme,
                        onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                        activeColor: activeColor,
                        inactiveThumbColor: inactiveThumbColor,
                        inactiveTrackColor: inactiveTrackColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
