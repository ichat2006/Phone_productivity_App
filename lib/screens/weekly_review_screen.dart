import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/usage_provider.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final usageProvider = Provider.of<UsageProvider>(context);
    final totalTasks = taskProvider.tasks.length;
    final completedTasks = taskProvider.tasks.where((t) => t.isDone).length;
    final prompts = usageProvider.interventionCount;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tasks completed: $completedTasks / $totalTasks', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Focus prompts triggered: $prompts', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            if (completedTasks > 0) ...[
              const Text('Completed Tasks:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...taskProvider.tasks.where((t) => t.isDone).map((t) => Text(' - ${t.title}', style: const TextStyle(fontSize: 16))),
            ],
            if (completedTasks == 0)
              const Text('No tasks completed this week.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
