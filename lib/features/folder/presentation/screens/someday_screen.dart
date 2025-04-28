import 'package:flutter/material.dart';

class SomedayScreen extends StatelessWidget {
  const SomedayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Когда-нибудь'),
      ),
      body: const Center(
        child: Text('Экран Когда-нибудь'),
      ),
    );
  }
}