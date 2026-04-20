import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_buisness/provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = FirebaseAuth.instance;

      final result = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = result.user;

      if (user != null && !user.emailVerified) {
        if (!mounted) return;
        setState(() {
          _errorMessage = "Bitte bestätige deine E-Mail-Adresse.";
          _isLoading = false;
        });
        await auth.signOut();
        return;
      }

      await Provider.of<UserProvider>(context, listen: false)
          .loadUserDataFromFirebase();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _getFriendlyError(e.code);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Unbekannter Fehler. Bitte versuche es erneut.";
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getFriendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return "❌ Kein Benutzer mit dieser E-Mail gefunden.";
      case 'wrong-password':
        return "❌ Falsches Passwort.";
      case 'invalid-email':
        return "❌ Ungültige E-Mail-Adresse.";
      case 'user-disabled':
        return "❌ Dieses Konto wurde deaktiviert.";
      case 'network-request-failed':
        return "❌ Keine Internetverbindung.";
      default:
        return "❌ Fehler: $code";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Text(
                "Willkommen zurück!",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 📧 E-Mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-Mail",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "E-Mail darf nicht leer sein.";
                  }
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$')
                      .hasMatch(value)) {
                    return "Ungültige E-Mail-Adresse.";
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
                autofillHints: const [AutofillHints.password],
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Mindestens 6 Zeichen";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // 🔑 Passwort vergessen
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text("Passwort vergessen?"),
                ),
              ),

              const SizedBox(height: 16),

              // ❌ Fehleranzeige
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // ✅ Login-Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Einloggen"),
              ),

              const SizedBox(height: 24),

              // 👤 Registrierung
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Noch kein Konto?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Jetzt registrieren"),
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
