import 'package:flutter/material.dart';
import 'package:todo_app_buisness/config/app_ads_config.dart';

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppAdsConfig.isPremiumUser) {
      return const SizedBox.shrink(); // Kein Banner bei Premium
    }

    // Hier würdest du dein echtes Ad-Widget einfügen (z. B. AdMob)
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(12),
      child: const Center(
        child: Text(
          '🔔 Werbung – Upgrade für keine Ads!',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
