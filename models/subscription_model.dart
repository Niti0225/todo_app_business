import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionModel {
  static const String _keyPremium = 'is_premium_user';

  static Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPremium) ?? false;
  }

  static Future<void> setPremiumUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, value);
  }
}
