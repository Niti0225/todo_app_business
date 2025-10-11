import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hilfe & FAQ")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text("Wie erstelle ich eine Aufgabe?"),
            children: [Padding(
              padding: EdgeInsets.all(8),
              child: Text("Gehe zur Startseite und tippe auf '+'."),
            )],
          ),
          ExpansionTile(
            title: Text("Wie ändere ich mein Passwort?"),
            children: [Padding(
              padding: EdgeInsets.all(8),
              child: Text("Im Profilbereich unter 'Passwort ändern'."),
            )],
          ),
        ],
      ),
    );
  }
}
