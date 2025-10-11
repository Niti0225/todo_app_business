import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskTitle extends StatelessWidget {
  final TaskModel task;

  const TaskTitle({super.key, required this.task});

  Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.orangeAccent;
      case TaskPriority.low:
        return Colors.greenAccent;
    }
  }

  String getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return "HOCH";
      case TaskPriority.medium:
        return "MITTEL";
      case TaskPriority.low:
        return "NIEDRIG";
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final theme = Theme.of(context);

    final priorityColor = getPriorityColor(task.priority);
    final priorityText = getPriorityText(task.priority);
    final formattedDate = formatDate(task.dueDate);

    final strike = task.isCompleted ? TextDecoration.lineThrough : null;

    return Opacity(
      opacity: task.isCompleted ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Toggle Completion
            GestureDetector(
              onTap: () async {
                final updatedTask =
                    task.copyWith(isCompleted: !task.isCompleted);
                await taskProvider.updateTask(updatedTask);

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(updatedTask.isCompleted
                          ? 'Aufgabe als erledigt markiert.'
                          : 'Aufgabe als offen markiert.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              },
              child: Icon(
                task.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.greenAccent : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // 📄 Task Info (clickable)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>
                    Navigator.pushNamed(context, '/detail', arguments: task),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: strike,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                        decoration: strike,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "Fällig: $formattedDate",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: strike,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 🟢 Priority label
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    priorityText,
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
