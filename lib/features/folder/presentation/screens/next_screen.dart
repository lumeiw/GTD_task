import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Следующий'),
      ),
      body: const Center(
        child: Text('Экран Следующий'),
      ),
    );
  }
}