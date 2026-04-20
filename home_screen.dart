import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app_buisness/models/task_model.dart';
import 'package:todo_app_buisness/provider/task_provider.dart';
import 'package:todo_app_buisness/provider/user_provider.dart';
import 'package:todo_app_buisness/widgets/task_card.dart';
import 'package:todo_app_buisness/screens/profile_screen.dart';
import 'package:todo_app_buisness/screens/calender/calender_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = const [
    _TaskPage(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task_outlined), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Kalender'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class _TaskPage extends StatelessWidget {
  const _TaskPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Consumer2<UserProvider, TaskProvider>(
        builder: (_, userProvider, taskProvider, __) {
          final userName = userProvider.username ?? 'Gast';
          final allTasks = taskProvider.tasks;
          final today = _todayTasks(allTasks);
          final upcoming = _upcomingTasks(allTasks);
          final completedToday = today.where((t) => t.isCompleted).length;

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Willkommen zurück",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Meine Aufgaben",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // 👉 Aufgabenliste
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _SectionHeader(
                        title: "Heute",
                        subtitle: "$completedToday von ${today.length} erledigt",
                      ),
                      if (today.isEmpty)
                        _EmptyText("Keine Aufgaben für heute")
                      else
                        ...today.map((task) => TaskCard(
                              task: task,
                              onToggle: () => _toggleTask(context, task),
                            )),
                      const SizedBox(height: 24),
                      const _SectionHeader(title: "Demnächst"),
                      if (upcoming.isEmpty)
                        _EmptyText("Keine kommenden Aufgaben")
                      else
                        ...upcoming.map((task) => TaskCard(
                              task: task,
                              onToggle: () => _toggleTask(context, task),
                            )),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                const _CreateTaskButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  static List<TaskModel> _todayTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      final due = task.dueDate;
      return due.year == now.year && due.month == now.month && due.day == now.day;
    }).toList();
  }

  static List<TaskModel> _upcomingTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasks.where((task) => task.dueDate.isAfter(today)).toList();
  }

  Future<void> _toggleTask(BuildContext context, TaskModel task) async {
    final provider = context.read<TaskProvider>();
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await provider.updateTask(updated);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(updated.isCompleted
            ? '✅ Aufgabe erledigt'
            : '🔁 Aufgabe wieder geöffnet'),
        duration: const Duration(seconds: 2),
      ));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (subtitle != null) ...[
            const SizedBox(width: 8),
            Text(subtitle!, style: TextStyle(color: Colors.grey[500])),
          ]
        ],
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: TextStyle(color: Colors.grey[500])),
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  const _CreateTaskButton();

  @override
  Widget build(BuildContext context) {
    final onPressed = () => Navigator.pushNamed(context, '/create');
    const label = Text(
      '+ Neue Aufgabe',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS)
          ? CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(vertical: 16),
              borderRadius: BorderRadius.circular(12),
              onPressed: onPressed,
              child: label,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 8,
              ),
              child: label,
            ),
    );
  }
}
