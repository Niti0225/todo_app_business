import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_buisness/models/task_model.dart';
import 'package:todo_app_buisness/provider/task_provider.dart';
import 'package:todo_app_buisness/widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;

    final events = <DateTime, List<TaskModel>>{};
    for (var t in tasks) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      events.putIfAbsent(d, () => []).add(t);
    }

    final selectedTasks = _selectedDay != null
        ? events[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? []
        : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      body: Column(
        children: [
          TableCalendar<TaskModel>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              final key = DateTime(day.year, day.month, day.day);
              return events[key] ?? [];
            },
            startingDayOfWeek: StartingDayOfWeek.monday, // 👉 Woche beginnt mit Montag
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(
                color: Colors.red, // 👉 Samstag & Sonntag in Rot
                fontWeight: FontWeight.bold,
              ),
              weekdayStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            calendarBuilders: CalendarBuilders<TaskModel>(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: selectedTasks.isEmpty
                ? const Center(child: Text('Keine Aufgaben an diesem Tag.'))
                : ListView.builder(
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, i) {
                      final task = selectedTasks[i];
                      return TaskCard(
                        task: task,
                        onToggle: () async {
                          final provider = context.read<TaskProvider>();
                          final updated = task.copyWith(isCompleted: !task.isCompleted);
                          await provider.updateTask(updated);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay != null) {
            Navigator.pushNamed(
              context,
              '/create',
              arguments: _selectedDay,
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
