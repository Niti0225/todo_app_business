import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/task_provider.dart';
import '../../widgets/task_title.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Meine Aufgaben'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await Provider.of<TaskProvider>(context, listen: false).loadTasks();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Aufgabenliste aktualisiert"),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          final tasks = provider.tasks;

          final sortedTasks = [...tasks]..sort((a, b) {
            if (a.isDone == b.isDone) return 0;
            return a.isDone ? 1 : -1;
          });

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (sortedTasks.isEmpty) {
            return const Center(
              child: Text(
                "Keine Aufgaben vorhanden",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            itemCount: sortedTasks.length,
            itemBuilder: (context, index) {
              final task = sortedTasks[index];
              return Hero(
                tag: task.id,
                child: Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: TaskTitle(task: task),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Neue Aufgabe hinzufügen',
        onPressed: () async {
          await Navigator.pushNamed(context, '/create');

          // Nach Rückkehr neu laden
          await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
