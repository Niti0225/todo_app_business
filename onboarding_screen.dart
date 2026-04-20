import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../auth/auth_gate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.add_task,
      "title": "Aufgaben hinzufügen",
      "desc": "Erstelle Aufgaben und organisiere deinen Tag effizient.",
    },
    {
      "icon": Icons.star_border,
      "title": "Prioritäten setzen",
      "desc": "Markiere Aufgaben als wichtig oder weniger wichtig.",
    },
    {
      "icon": Icons.calendar_today,
      "title": "Kalenderintegration",
      "desc": "Plane deine Aufgaben im Kalender und behalte den Überblick.",
    },
    {
      "icon": Icons.workspace_premium_outlined,
      "title": "Kostenlose & Premium-Version",
      "desc":
          "Diese App zeigt Werbung an. Mit einem Upgrade (einmalig 3,99 €) bekommst du ein werbefreies Erlebnis.",
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final item = _pages[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item["icon"],
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 40),
                Text(
                  item["title"],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  item["desc"],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: index == _pages.length - 1
                      ? _finishOnboarding
                      : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                  child: Text(
                    index == _pages.length - 1 ? 'Loslegen' : 'Weiter',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
