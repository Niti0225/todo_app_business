import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_buisness/provider/user_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoggedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      debugPrint("🔄 Auth State geändert: ${user?.email ?? 'Abgemeldet'}");
      notifyListeners();
    });
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ FirebaseAuthException: ${e.code} — ${e.message}");

      switch (e.code) {
        case 'invalid-credential':
          throw Exception("❗ Ungültige Anmeldedaten. Bitte überprüfe E-Mail und Passwort.");
        case 'user-not-found':
          throw Exception("❗ Kein Benutzer mit dieser E-Mail gefunden.");
        case 'wrong-password':
          throw Exception("❗ Falsches Passwort.");
        case 'user-disabled':
          throw Exception("❗ Dieser Benutzer wurde deaktiviert.");
        default:
          throw Exception("❗ Authentifizierungsfehler: ${e.message}");
      }
    } catch (e) {
      debugPrint("❌ Unbekannter Fehler beim Login: $e");
      throw Exception("❗ Ein unbekannter Fehler ist aufgetreten.");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.resetUserData();
    } catch (e) {
      debugPrint("❌ Logout fehlgeschlagen: $e");
    }
  }
}
