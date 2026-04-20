import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../provider/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  String getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return "HIGH";
      case TaskPriority.medium:
        return "MEDIUM";
      case TaskPriority.low:
        return "LOW";
    }
  }

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

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final TaskModel task = ModalRoute.of(context)!.settings.arguments as TaskModel;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit",
            onPressed: () {
              Navigator.pushNamed(context, '/edit', arguments: task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Delete",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Delete Task"),
                  content: const Text("Do you really want to delete this task?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text("Delete"),
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(task.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                task.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                "Description",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                task.description,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),

              // Due Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "Due: ${formatDate(task.dueDate)}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Priority Badge
              Row(
                children: [
                  const Icon(Icons.flag_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getPriorityColor(task.priority).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getPriorityText(task.priority),
                      style: TextStyle(
                        color: getPriorityColor(task.priority),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    task.isCompleted ? "Completed" : "Pending",
                    style: TextStyle(
                      color: task.isCompleted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
