import 'package:flutter/material.dart';
import '../../config/app_ads_config.dart';
import '../../models/subscription_model.dart';

class PremiumUpgradeScreen extends StatelessWidget {
  const PremiumUpgradeScreen({super.key});

  Future<void> _buyPlan(BuildContext context, String plan) async {
    // Simuliere Upgrade → du kannst hier echte Logik für In-App Purchases einbauen
    await SubscriptionModel.setPremiumUser(true);
    AppAdsConfig.setPremiumStatus(true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🎉 Upgrade erfolgreich: $plan freigeschaltet!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // zurück zur vorherigen Seite
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Premium Upgrade'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium_outlined, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              "Wähle dein Upgrade",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // ➤ Kostenlos
            _buildPlanCard(
              context,
              title: "Kostenlos",
              price: "0 €",
              description: "Mit Werbung",
              features: const ["Zugriff auf Basisfunktionen", "Werbung enthalten"],
              color: Colors.grey[800]!,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Du nutzt bereits die kostenlose Version.")),
                );
              },
            ),

            // ➤ Monatlich
            _buildPlanCard(
              context,
              title: "Premium Monatlich",
              price: "1,99 € / Monat",
              description: "Keine Werbung",
              features: const ["Werbefrei", "Premium-Features", "Schnellere Ladezeiten"],
              color: Colors.amber[700]!,
              onTap: () => _buyPlan(context, "Monatlich"),
            ),

            // ➤ Lebenslang
            _buildPlanCard(
              context,
              title: "Premium Lebenslang",
              price: "80 € einmalig",
              description: "Nie wieder Werbung",
              features: const ["Alle Premium-Vorteile", "Für immer freigeschaltet"],
              color: Colors.deepPurple,
              onTap: () => _buyPlan(context, "Lebenslang"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(price, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              ...features.map(
                (feature) => Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(feature, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
