import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ожидание'),
      ),
      body: const Center(
        child: Text('Экран Ожидание'),
      ),
    );
  }
}