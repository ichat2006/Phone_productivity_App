import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/usage_provider.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If tasks are not yet loaded, start listening for current user’s tasks
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (authProvider.isLoggedIn && taskProvider.tasks.isEmpty) {
      taskProvider.startListening(authProvider.user!.uid);
    }
    // Listen for usage provider changes to show intervention prompt
    final usageProvider = Provider.of<UsageProvider>(context);
    if (usageProvider.needInterventionPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Show focus intervention prompt dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Stay Focused'),
            content: Text(usageProvider.promptMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Clear the prompt so it doesn't show again immediately
                  Provider.of<UsageProvider>(context, listen: false).clearPrompt();
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined),
            tooltip: 'Weekly Review',
            onPressed: () {
              Navigator.pushNamed(context, '/weekly-review');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () {
              // Sign out user
              Provider.of<TaskProvider>(context, listen: false).stopListening();
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            subtitle: task.description != null && task.description!.isNotEmpty
                ? Text(task.description!)
                : null,
            leading: Checkbox(
              value: task.isDone,
              onChanged: (bool? value) {
                Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task);
              },
            ),
            onTap: () {
              Navigator.pushNamed(context, '/task-detail', arguments: task.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
