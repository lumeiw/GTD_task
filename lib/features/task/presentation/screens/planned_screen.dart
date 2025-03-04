import 'package:flutter/material.dart';

class PlannedScreen extends StatelessWidget {
  const PlannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('В планах'),
      ),
      body: const Center(
        child: Text('Экран в планах'),
      ),
    );
  }
}