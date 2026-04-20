import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_buisness/provider/auth_provider.dart';
import 'package:todo_app_buisness/provider/user_provider.dart';
import 'package:todo_app_buisness/screens/home/home_screen.dart';
import 'package:todo_app_buisness/screens/auth/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.currentUser != null) {
      // 🧠 Benutzerdaten laden, falls vorhanden
      await context.read<UserProvider>().loadUserDataFromFirebase();
    }

    // ⏱ Warte auf Auth-Initialisierung
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.currentUser != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
