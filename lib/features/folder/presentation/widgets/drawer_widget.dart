import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/features/project/presentation/widget/project_list_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100.0,
            decoration: const BoxDecoration(color: Colors.black),
            child: const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'GTD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Входящие',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inbox, color: Colors.white),
            title: const Text('Inbox', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              context.go('/task-list-screen/inbox');
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Статусы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward, color: Colors.blue),
            title: const Text('В работе', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              context.go('/task-list-screen/inProgress');
            },
          ),
          ListTile(
            leading: const Icon(Icons.hourglass_empty, color: Colors.yellow),
            title: const Text('Ожидание', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              context.go('/task-list-screen/waiting');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.cyan),
            title: const Text('Запланировано', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              context.go('/task-list-screen/planned');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_late, color: Colors.pink),
            title: const Text('Когда-нибудь', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer(); 
              context.go('/task-list-screen/someday');
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Завершено', style: TextStyle(color: Colors.white)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              context.go('/task-list-screen/completed');
            },
          ),
          const ProjectListWidget(),
        ],
      ),
    );
  }
}