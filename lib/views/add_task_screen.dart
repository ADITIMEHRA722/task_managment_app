
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../viewmodels/task_viewmodel.dart';
import '../models/task_model.dart';

class AddTaskScreen extends ConsumerWidget {
  final Task? task; // Nullable Task parameter to check if editing
  AddTaskScreen({this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController(text: task?.title ?? "");

    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 254, 254, 254),
      appBar: AppBar(title: Text(task == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;

                if (task == null) {
                  // Add new task
                  ref.read(taskViewModelProvider).addTask(_controller.text);
                } else {
                  // Update existing task
                  Task updatedTask = Task(id: task!.id, title: _controller.text, isCompleted: task!.isCompleted);
                  ref.read(taskViewModelProvider).updateTask(updatedTask);
                }

                Navigator.pop(context);
              },
              child: Text(task == null ? "Add Task" : "Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}
