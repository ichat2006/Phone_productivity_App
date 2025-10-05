import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  StreamSubscription<List<Task>>? _tasksSub;

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Start listening to task updates for the given user
  void startListening(String userId) {
    // Cancel any existing subscription
    _tasksSub?.cancel();
    _tasksSub = TaskService.streamTasks(userId).listen((tasksList) {
      _tasks = tasksList;
      notifyListeners();
    });
  }

  // Stop listening to tasks (e.g., on logout) and clear current tasks
  void stopListening() {
    _tasksSub?.cancel();
    _tasksSub = null;
    _tasks = [];
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String title, String? description) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // Add task to Firestore (this will also trigger the stream listener)
    await TaskService.addTask(user.uid, title, description);
    // No need to manually add to _tasks because stream will update the list
  }

  // Update an existing task's details
  Future<void> updateTask(Task task) async {
    // Update task in Firestore
    await TaskService.updateTask(task.id, {
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
    });
    // We rely on the stream to update the list, but update locally for responsiveness
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  // Toggle a task's completion status
  Future<void> toggleTaskStatus(Task task) async {
    task.isDone = !task.isDone;
    await TaskService.updateTask(task.id, {'isDone': task.isDone});
    // Update local list to reflect change immediately
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }
}
