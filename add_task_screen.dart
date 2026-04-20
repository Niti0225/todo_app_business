import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../provider/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newTask = TaskModel(
        id: '', // Wird z.B. in Firestore oder lokal generiert
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: false,
      );

      await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      Navigator.pop(context); // Zurück zur vorherigen Seite
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Aufgabe erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titel'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Titel erforderlich';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
              ),
              const SizedBox(height: 16),

              // Priorität Dropdown
              Row(
                children: [
                  const Icon(Icons.flag),
                  const SizedBox(width: 8),
                  const Text("Priorität: "),
                  DropdownButton<TaskPriority>(
                    value: _priority,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
                    items: TaskPriority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Datum wählen
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text("Fällig am: ${_dueDate.toLocal().toIso8601String().split('T')[0]}"),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Datum ändern"),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Speichern Button
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Aufgabe erstellen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
