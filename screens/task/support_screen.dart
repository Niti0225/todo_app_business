import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _contactSupport(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@deineapp.de',
      query: 'subject=Support Anfrage&body=Hallo Support-Team, ich brauche Hilfe bei ...',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konnte keine E-Mail-App öffnen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontakt & Support')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.support_agent),
          label: const Text("Support kontaktieren"),
          onPressed: () => _contactSupport(context),
        ),
      ),
    );
  }
}
