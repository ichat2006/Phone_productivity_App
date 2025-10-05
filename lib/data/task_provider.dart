import 'package:flutter/foundation.dart';
import '../../models/task.dart';
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

}
