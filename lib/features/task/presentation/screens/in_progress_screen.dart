import 'package:flutter/material.dart';

class InProgressScreen extends StatelessWidget {
  const InProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('В работе'),
      ),
      body: const Center(
        child: Text('Экран В работе'),
      ),
    );
  }
}