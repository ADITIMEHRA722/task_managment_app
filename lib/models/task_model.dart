class Task {
  int? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  // Convert a Task object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted ? 1 : 0};
  }

  // Convert a Map from the database to a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'], title: map['title'], isCompleted: map['isCompleted'] == 1);
  }
}

