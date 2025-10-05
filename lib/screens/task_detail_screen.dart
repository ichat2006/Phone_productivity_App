import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)!.settings.arguments as String;

    final tasks = context.watch<TaskProvider>().tasks;
    Task? task;
    for (final t in tasks) {
      if (t.id == taskId) {
        task = t;
        break;
      }
    }

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: const Center(child: Text('Task not found.')),
      );
    }

    // 👇 capture as non-null to use safely inside closures
    final t = task!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-task', arguments: t.id);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if ((t.description ?? '').isNotEmpty) ...[
              Text(t.description!, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
            ],
            Text('Status: ${t.isDone ? "Completed" : "Incomplete"}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
