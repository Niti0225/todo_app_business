import 'package:cloud_firestore/cloud_firestore.dart';

/// Prioritätsstufen für eine Aufgabe
enum TaskPriority { low, medium, high }

/// Erweiterung für zusätzliche Funktionalität bei TaskPriority
extension TaskPriorityExtension on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return "Niedrig";
      case TaskPriority.medium:
        return "Mittel";
      case TaskPriority.high:
        return "Hoch";
    }
  }

  int get weight {
    switch (this) {
      case TaskPriority.low:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.high:
        return 2;
    }
  }

  String get nameUpper => name.toUpperCase();
}

/// Repräsentiert eine Aufgabe
class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final String? category;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    this.category,
  });

  /// 🔁 Erstellt eine Instanz aus Firestore-Daten
  factory TaskModel.fromMap(Map<String, dynamic> data, String documentId) {
    final Timestamp? ts = data['dueDate'] as Timestamp?;
    final int priorityIndex = data['priority'] ?? 1;

    return TaskModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: ts != null ? ts.toDate() : DateTime.now(),
      priority: TaskPriority.values.asMap().containsKey(priorityIndex)
          ? TaskPriority.values[priorityIndex]
          : TaskPriority.medium,
      isCompleted: data['isCompleted'] ?? false,
      category: data['category'],
    );
  }

  /// 🔁 Wandelt das Objekt in ein Firestore-kompatibles Map um
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.index,
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  /// 🧬 Gibt eine Kopie mit optionalen Änderungen zurück
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    String? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }

  /// ✅ Zusätzliche Getter (Kompatibilität mit bestehendem Code)

  /// Getter für `isDone` (alias für `isCompleted`)
  bool get isDone => isCompleted;

  /// Getter für `date` (alias für `dueDate`)
  DateTime get date => dueDate;

  /// 📅 Überprüft, ob Aufgabe überfällig ist
  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, due: $dueDate, priority: $priority, completed: $isCompleted, category: $category)';
  }
}
