import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onToggle; // ✅ Neuer optionaler Callback

  const TaskCard({
    super.key,
    required this.task,
    this.onToggle,
  });

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.amberAccent;
      case TaskPriority.low:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Checkbox mit Callback
          GestureDetector(
            onTap: onToggle, // Nutzt jetzt den übergebenen Callback
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.greenAccent : Colors.grey,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          // 📄 Inhalt
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (task.category != null && task.category!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      'Fällig: ${DateFormat('dd.MM.yyyy').format(task.dueDate)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 🟡 Priorität
          Text(
            task.priority.label.toUpperCase(),
            style: TextStyle(
              color: _priorityColor(task.priority),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}