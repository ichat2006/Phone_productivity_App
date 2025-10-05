class Task {
  String id;
  String title;
  String? description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
  });

  // Construct a Task object from Firestore document data
  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      description: data.containsKey('description') ? data['description'] as String? : null,
      isDone: data['isDone'] ?? false,
    );
  }

  // Convert Task object to a Map for storing in Firestore
  Map<String, dynamic> toMap(String userId) {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'userId': userId,
    };
  }
}

