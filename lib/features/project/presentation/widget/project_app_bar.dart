import 'package:flutter/material.dart';

class ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String projectName;

  const ProjectAppBar({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.primary,
      title: Text(
        projectName,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      leading: Builder(
        builder: (innerContext) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(innerContext).openDrawer();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}