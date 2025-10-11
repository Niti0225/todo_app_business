import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:todo_app_buisness/provider/user_provider.dart';
import 'package:todo_app_buisness/provider/auth_provider.dart' as myAuth;
import 'package:todo_app_buisness/screens/upgrade/premium_upgrade_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>();
    final username = userProvider.username;
    final profileImageUrl = userProvider.profileImageUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ✅ Profilbild mit Upload
          Center(
            child: GestureDetector(
              onTap: () => _pickAndUploadImage(context),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null, // ✅ Kein falsches Komma mehr
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Benutzername
          Center(
            child: Column(
              children: [
                Text("Angemeldet als:", style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(username, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ✅ Premium Optionen
          _buildSectionTitle(context, "Upgrade & Premium 🚀"),
          _buildPremiumOption(
            context,
            icon: Icons.ads_click_outlined,
            title: "Kostenlos (mit Werbung)",
            description: "Vollzugriff mit gelegentlicher Werbung",
            color: Colors.grey,
            onTap: () {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Du nutzt aktuell die kostenlose Version"),
                ),
              );
            },
          ),
          _buildPremiumOption(
            context,
            icon: Icons.workspace_premium_outlined,
            title: "Werbefrei (1,99 € / Monat)",
            description: "Keine Werbung für 30 Tage",
            color: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PremiumUpgradeScreen(),
                ),
              );
            },
          ),
          _buildPremiumOption(
            context,
            icon: Icons.star,
            title: "Lebenslang Premium (80 € einmalig)",
            description: "Keine Werbung. Für immer.",
            color: Colors.deepPurpleAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PremiumUpgradeScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // ✅ Konto & Sicherheit
          _buildSectionTitle(context, "Konto & Sicherheit"),
          _buildTile(
            context,
            icon: Icons.person_outline,
            label: "Profil bearbeiten",
            route: '/edit-profile',
          ),
          _buildTile(
            context,
            icon: Icons.lock_outline,
            label: "Passwort ändern",
            route: '/change-password',
          ),
          _buildTile(
            context,
            icon: Icons.logout,
            label: "Abmelden",
            onTap: () async {
              await Provider.of<myAuth.AuthProvider>(
                context,
                listen: false,
              ).logout(context);

              Provider.of<UserProvider>(context, listen: false).resetUserData();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // ✅ Hilfe & Feedback
          _buildSectionTitle(context, "Hilfe & Feedback"),
          _buildTile(
            context,
            icon: Icons.feedback_outlined,
            label: "App-Feedback geben",
            route: '/feedback',
          ),
          _buildTile(
            context,
            icon: Icons.help_outline,
            label: "Hilfe / FAQ",
            route: '/faq',
          ),
          _buildTile(
            context,
            icon: Icons.privacy_tip_outlined,
            label: "Datenschutz & Nutzungsbedingungen",
            route: '/privacy-policy',
          ),
          _buildTile(
            context,
            icon: Icons.support_agent_outlined,
            label: "Kontakt / Support",
            route: '/support',
          ),

          const SizedBox(height: 24),

          // ✅ Externe Links zu GitHub Pages
          _buildSectionTitle(context, "Rechtstexte Online 🌐"),
          _buildLinkButton(
            icon: Icons.privacy_tip,
            label: "Datenschutz (DE)",
            url: "https://niti0225.github.io/todo_app_business/privacy_de.html",
          ),
          _buildLinkButton(
            icon: Icons.privacy_tip_outlined,
            label: "Privacy Policy (EN)",
            url: "https://niti0225.github.io/todo_app_business/privacy_en.html",
          ),
          _buildLinkButton(
            icon: Icons.description,
            label: "Nutzungsbedingungen (DE)",
            url: "https://niti0225.github.io/todo_app_business/terms_de.html",
          ),
          _buildLinkButton(
            icon: Icons.description_outlined,
            label: "Terms of Use (EN)",
            url: "https://niti0225.github.io/todo_app_business/terms_en.html",
          ),
          _buildLinkButton(
            icon: Icons.support,
            label: "Support (DE)",
            url: "https://niti0225.github.io/todo_app_business/support_de.html",
          ),
          _buildLinkButton(
            icon: Icons.support_agent,
            label: "Support (EN)",
            url: "https://niti0225.github.io/todo_app_business/support_en.html",
          ),
          _buildLinkButton(
            icon: Icons.feedback,
            label: "Feedback (DE)",
            url: "https://niti0225.github.io/todo_app_business/feedback_de.html",
          ),
          _buildLinkButton(
            icon: Icons.feedback_outlined,
            label: "Feedback (EN)",
            url: "https://niti0225.github.io/todo_app_business/feedback_en.html",
          ),
          _buildLinkButton(
            icon: Icons.workspace_premium,
            label: "Premium Upgrade (DE)",
            url: "https://niti0225.github.io/todo_app_business/premium_de.html",
          ),
          _buildLinkButton(
            icon: Icons.workspace_premium_outlined,
            label: "Premium Upgrade (EN)",
            url: "https://niti0225.github.io/todo_app_business/premium_en.html",
          ),

          const SizedBox(height: 24),

          // ✅ Versionsinfo
          Center(
            child: Text("Version 1.0.0", style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  // --- Hilfs-Widgets ---

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap ??
          () {
            if (route != null) {
              Navigator.pushNamed(context, route);
            }
          },
    );
  }

  Widget _buildPremiumOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description,
            style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white54, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLinkButton({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, color: Colors.blueGrey),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');

    try {
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'profileImageUrl': url}, SetOptions(merge: true));

      Provider.of<UserProvider>(context, listen: false).setProfileImageUrl(url);

      _showSnackBar(context, "✅ Profilbild aktualisiert.");
    } catch (e) {
      _showSnackBar(context, "❌ Fehler beim Hochladen: ${e.toString()}");
    }
  }
}
