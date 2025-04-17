import 'package:flutter/material.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key, required this.projectName});
  
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
      ),
      body: Center(
        child: Text(
          'Details of $projectName',
        ),
      ),
    );
  }
}
