import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<TaskModel> _tasks = [];
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔄 Aufgaben aus Firestore laden:
  /// - Heute: alle anzeigen
  /// - Vorher: nur nicht erledigte
  Future<void> fetchTasks() async {
    _setLoading(true);
    notifyListeners();

    try {
      final snapshot = await _taskCollection.orderBy('dueDate').get();

      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      final fetchedTasks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final task = TaskModel.fromMap(data, doc.id);

        final taskDate = DateTime(
          task.dueDate.year,
          task.dueDate.month,
          task.dueDate.day,
        );

        final isToday = taskDate == todayOnly;
        final show = isToday || !task.isCompleted;

        return show ? task : null;
      }).whereType<TaskModel>().toList();

      _tasks
        ..clear()
        ..addAll(fetchedTasks);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Fehler beim Laden: $e";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    _setLoading(true);
    notifyListeners();

    try {
      final docRef = await _taskCollection.add(task.toMap());
      final newTask = task.copyWith(id: docRef.id);
      _tasks.add(newTask);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Fehler beim Hinzufügen: $e";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    _setLoading(true);

    try {
      await _taskCollection.doc(task.id).update(task.toMap());

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Fehler beim Aktualisieren: $e";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _setLoading(true);

    try {
      await _taskCollection.doc(id).delete();
      _tasks.removeWhere((t) => t.id == id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Fehler beim Löschen: $e";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  Future<void> loadTasks() => fetchTasks();
}
