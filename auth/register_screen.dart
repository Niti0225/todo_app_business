import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_buisness/provider/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = FirebaseAuth.instance;

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      final username = _usernameController.text.trim();

      if (user != null) {
        await user.updateDisplayName(username);

        // Optional: E-Mail-Bestätigung senden
        // await user.sendEmailVerification();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUsername(username);
        await userProvider.loadUserDataFromFirebase();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getFriendlyError(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Unbekannter Fehler. Bitte versuche es erneut.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getFriendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Diese E-Mail ist bereits registriert.";
      case 'invalid-email':
        return "Ungültige E-Mail-Adresse.";
      case 'weak-password':
        return "Das Passwort ist zu schwach.";
      case 'network-request-failed':
        return "Keine Internetverbindung.";
      default:
        return "Fehler: $code";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Registrieren")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Erstelle einen Account", style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),

              // 👤 Benutzername
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Benutzername",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Bitte Benutzernamen eingeben"
                    : null,
              ),
              const SizedBox(height: 16),

              // 📧 E-Mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-Mail",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "E-Mail darf nicht leer sein.";
                  }
                  if (!value.contains('@')) {
                    return "Gültige E-Mail eingeben.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Passwort
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Passwort",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6
                        ? "Mindestens 6 Zeichen"
                        : null,
              ),
              const SizedBox(height: 24),

              // ❌ Fehleranzeige
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 12),

              // ✅ Registrieren-Button
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Registrieren"),
              ),

              const SizedBox(height: 24),

              // 🔙 Link zurück zum Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Schon registriert?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Jetzt einloggen"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
