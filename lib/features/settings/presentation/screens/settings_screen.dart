import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_task/core/theme/app_theme.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_cubit.dart';
import 'package:gtd_task/features/settings/presentation/cubit/theme/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Настройки'),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDarkTheme = switch (themeState) {
            ThemeLoaded state => state.themeData == AppTheme.darkTheme,
            _ => false,
          };

          return Container(
            color: Theme.of(context).colorScheme.primary,
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
                      Switch(
                        value: isDarkTheme,
                        onChanged: (value) {
                          // Переключаем тему при изменении значения Switch
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeColor: isDarkTheme
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                        inactiveThumbColor: isDarkTheme
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSecondary,
                        inactiveTrackColor: isDarkTheme
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
