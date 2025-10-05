import 'package:flutter/material.dart';

// This file will contain the widget that displays the list of tasks.
// This helps keep the home_screen.dart file clean.

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    // This will eventually be a ListView.builder
    return const Center(
      child: Text('List of tasks.'),
    );
  }
}