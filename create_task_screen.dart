import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../provider/task_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  final DateTime? dateArg;

  const CreateTaskScreen({super.key, this.dateArg});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  late DateTime _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.dateArg ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submitTask() async {
    if (_isSubmitting) return;
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      setState(() => _isSubmitting = true);

      final newTask = TaskModel(
        id: '',
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
      );

      await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aufgabe erfolgreich erstellt"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
    setState(() => _isSubmitting = false);
  }

  Widget _buildPriorityDropdown() {
    return DropdownButton<TaskPriority>(
      dropdownColor: Colors.grey[900],
      value: _priority,
      onChanged: (value) {
        if (value != null) setState(() => _priority = value);
      },
      items: TaskPriority.values.map((priority) {
        return DropdownMenuItem(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aufgabe erstellen')),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel
              TextFormField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _title = value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Titel erforderlich' : null,
              ),
              const SizedBox(height: 16),

              // Beschreibung
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 20),

              // Priorität
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text("Priorität:", style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 16),
                  _buildPriorityDropdown(),
                ],
              ),
              const SizedBox(height: 20),

              // Datum
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "Fällig am: ${_dueDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Datum ändern"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(
                    _isSubmitting ? 'Bitte warten...' : 'Aufgabe erstellen',
                  ),
                  onPressed: _isSubmitting ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
