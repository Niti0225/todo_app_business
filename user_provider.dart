import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String _username = 'Gast';
  String? _profileImageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get username => _username;
  String? get profileImageUrl => _profileImageUrl;

  /// 👤 Username setzen + Firestore speichern
  Future<void> setUsername(String name) async {
    if (name == _username) return;

    _username = name;
    notifyListeners();

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'username': name,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint("❌ Fehler beim Speichern des Benutzernamens für ${user.uid}: $e");
      }
    }
  }

  /// 🖼 Profilbild-URL setzen + Firestore speichern
  Future<void> setProfileImageUrl(String? url) async {
    if (url == null || url == _profileImageUrl) return;

    _profileImageUrl = url;
    notifyListeners();

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'profileImageUrl': url,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint("❌ Fehler beim Speichern des Profilbildes für ${user.uid}: $e");
      }
    }
  }

  /// 🔄 Daten vom angemeldeten Benutzer laden
  Future<void> loadUserDataFromFirebase() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("⚠️ Kein Benutzer angemeldet.");
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        _username = data['username'] ??
            user.displayName ??
            user.email?.split('@').first ??
            'Benutzer';

        _profileImageUrl = data['profileImageUrl'] as String?;
      } else {
        // 🆕 Neues Dokument erstellen mit Fallback-Name
        _username = user.displayName ?? user.email?.split('@').first ?? 'Benutzer';
        await docRef.set({
          'username': _username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("❌ Fehler beim Laden der Nutzerdaten von ${user.uid}: $e");
    }

    notifyListeners();
  }

  /// 🔓 Logout / Reset
  void resetUserData() {
    _username = 'Gast';
    _profileImageUrl = null;
    notifyListeners();
  }
}
