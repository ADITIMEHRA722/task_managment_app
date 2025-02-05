

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';

final taskViewModelProvider = ChangeNotifierProvider<TaskViewModel>((ref) => TaskViewModel());

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  final DatabaseService _dbService = DatabaseService();
  final PreferencesService _preferencesService = PreferencesService();
  
  String _searchQuery = "";
  String _filterStatus = "all"; // "all", "completed", "pending"

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<Task> get tasks => _filteredTasks;
  String get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  TaskViewModel() {
    fetchTasks();
    initNotifications();
  }

  // Initialize notifications
  void initNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  // Fetch tasks from database and apply filter and search
  Future<void> fetchTasks() async {
    _tasks = await _dbService.getTasks();
    _applyFilterAndSearch();
  }

  // Search tasks by name
  void searchTasks(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilterAndSearch();
  }

  // Filter tasks based on status (all, completed, pending)
  void filterTasks(String status) {
    _filterStatus = status;
    _applyFilterAndSearch();
  }

  // Apply both search and filter criteria
  void _applyFilterAndSearch() {
    _filteredTasks = _tasks.where((task) {
      bool matchesSearch = _searchQuery.isEmpty || task.title.toLowerCase().contains(_searchQuery);
      bool matchesFilter = (_filterStatus == "all") ||
          (_filterStatus == "completed" && task.isCompleted) ||
          (_filterStatus == "pending" && !task.isCompleted);
      return matchesSearch && matchesFilter;
    }).toList();

    notifyListeners();
  }

  // Toggle task status (completed or pending)
  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _dbService.updateTask(task);
    fetchTasks();
  }

  // Add a new task
  Future<void> addTask(String title) async {
    Task newTask = Task(title: title,);
    await _dbService.insertTask(newTask);
    fetchTasks();
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _dbService.updateTask(task);
    fetchTasks();
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    fetchTasks();
  }

  // Show notification for task reminders
  Future<void> showTaskReminderNotification(String title) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, "Task Reminder", platformDetails);
  }
}

