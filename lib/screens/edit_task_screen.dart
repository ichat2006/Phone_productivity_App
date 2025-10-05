import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Task? _task;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_task == null) {
      final taskId = ModalRoute.of(context)!.settings.arguments as String;
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      _task = null;
      for (var t in taskProvider.tasks) {
        if (t.id == taskId) {
          _task = t;
          break;
        }
      }
      if (_task != null) {
        _titleController.text = _task!.title;
        _descriptionController.text = _task!.description ?? '';
      }
    }
  }

  void _saveEdits() async {
    if (_task == null) return;
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      _isSaving = true;
    });
    // Update task fields
    _task!.title = _titleController.text.trim();
    _task!.description = _descriptionController.text.trim();
    await Provider.of<TaskProvider>(context, listen: false).updateTask(_task!);
    setState(() {
      _isSaving = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: _task == null
          ? const Center(child: Text('Task not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveEdits,
              child: _isSaving ? const CircularProgressIndicator() : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
