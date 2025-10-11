import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Future<void> _sendFeedbackEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'feedback@deineapp.de',
      query: 'subject=App Feedback&body=Mein Feedback:',
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
      appBar: AppBar(title: const Text('App-Feedback')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.mail_outline),
          label: const Text("Feedback senden"),
          onPressed: () => _sendFeedbackEmail(context),
        ),
      ),
    );
  }
}
