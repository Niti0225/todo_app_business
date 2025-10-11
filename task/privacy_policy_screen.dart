import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Datenschutz & AGB")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text("""
Diese App speichert deine Aufgaben lokal oder online, je nach Nutzung. 
Es werden keine sensiblen Daten an Dritte weitergegeben.

Für Fragen kannst du dich jederzeit an uns wenden.
          """),
        ),
      ),
    );
  }
}
