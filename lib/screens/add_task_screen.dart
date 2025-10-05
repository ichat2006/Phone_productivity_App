import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  void _saveTask() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      _isSaving = true;
    });
    await Provider.of<TaskProvider>(context, listen: false).addTask(
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
    );
    setState(() {
      _isSaving = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveTask,
              child: _isSaving ? const CircularProgressIndicator() : const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
