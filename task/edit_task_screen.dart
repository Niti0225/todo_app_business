import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../provider/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TaskPriority _priority;
  late DateTime _dueDate;
  late TaskModel _task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _task = ModalRoute.of(context)!.settings.arguments as TaskModel;
    _title = _task.title;
    _description = _task.description;
    _priority = _task.priority;
    _dueDate = _task.dueDate;
  }

  Future<void> _pickDate() async {
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedTask = _task.copyWith(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
      );
      Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aufgabe bearbeiten")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _title = value!.trim(),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Titel eingeben' : null,
              ),
              const SizedBox(height: 16),

              // Beschreibung
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value!.trim(),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Beschreibung eingeben' : null,
              ),
              const SizedBox(height: 16),

              // Priorität
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priorität',
                  border: OutlineInputBorder(),
                ),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(
                      priority.name.toUpperCase(),
                      style: TextStyle(
                        color: priority == TaskPriority.high
                            ? Colors.red
                            : priority == TaskPriority.medium
                                ? Colors.orange
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),

              // Datum
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Fällig am: ${_dueDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Datum ändern"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Aktualisieren"),
                  onPressed: _saveChanges,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
