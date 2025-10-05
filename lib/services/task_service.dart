import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  static final CollectionReference _tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  // Listen to tasks for a specific user (real-time updates)
  static Stream<List<Task>> streamTasks(String userId) {
    return _tasksCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Add a new task for a user and return the generated task ID
  static Future<String> addTask(String userId, String title, String? description) async {
    final newTaskData = {
      'title': title,
      'description': description,
      'isDone': false,
      'userId': userId,
    };
    DocumentReference docRef = await _tasksCollection.add(newTaskData);
    return docRef.id;
  }

  // Update an existing task (title/description/isDone)
  static Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    await _tasksCollection.doc(taskId).update(updatedData);
  }

  // Delete an existing task
  static Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
