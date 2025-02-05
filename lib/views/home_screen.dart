

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment_app/viewmodels/preferences_viewmodel.dart';
import 'package:task_managment_app/views/add_task_screen.dart';
import '../viewmodels/task_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskViewModel = ref.watch(taskViewModelProvider);
  final preferences = ref.watch(preferencesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        actions: [
          IconButton(
            icon: Icon(preferences.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => ref.read(preferencesProvider).toggleTheme(),
          ),
          DropdownButton<String>(
            value: preferences.sortOrder,
            items: [
              DropdownMenuItem(value: 'date', child: Text("Sort by Date")),
              DropdownMenuItem(value: 'priority', child: Text("Sort by Priority")),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(preferencesProvider).setSortOrder(value);
                ref.read(taskViewModelProvider).fetchTasks();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => ref.read(taskViewModelProvider).searchTasks(value),
            ),
          ),

          // Filter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _filterButton(context, ref, "All", "all", taskViewModel.filterStatus),
              _filterButton(context, ref, "Completed", "completed", taskViewModel.filterStatus),
              _filterButton(context, ref, "Pending", "pending", taskViewModel.filterStatus),
            ],
          ),

          // Task List
          Expanded(
            child: taskViewModel.tasks.isEmpty
                ? Center(child: Text("No tasks found!"))
                : ListView.builder(
                    itemCount: taskViewModel.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskViewModel.tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => ref.read(taskViewModelProvider).toggleTaskStatus(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(task.isCompleted ? "Completed" : "Pending"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.deepPurple),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddTaskScreen(task: task),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => ref.read(taskViewModelProvider).deleteTask(task.id!),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _filterButton(BuildContext context, WidgetRef ref, String text, String filter, String currentFilter) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          ref.read(taskViewModelProvider).filterTasks(filter);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: currentFilter == filter ? Colors.deepPurple : Colors.grey,
          foregroundColor: Colors.white,
        ),
        child: Text(text),
      ),
    );
  }
}
