import 'package:flutter/material.dart';

// This file will contain the widget for a single item (a single task) in the list.
// It will be the row that shows the task's title and a checkbox.

class TaskTile extends StatelessWidget {
  const TaskTile({super.key});

  @override
  Widget build(BuildContext context) {
    // This will be a Card containing a ListTile.
    return const ListTile(
      leading: Icon(Icons.check_box_outline_blank),
      title: Text('A single task will be shown here'),
    );
  }
}