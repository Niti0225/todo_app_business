import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'routes.dart';
import 'config/app_theme.dart';

// Provider
import 'provider/auth_provider.dart' as myAuth;
import 'provider/task_provider.dart';
import 'provider/user_provider.dart';

// Screens
import 'screens/task/create_task_screen.dart';
import 'screens/calender/calender_screen.dart';
import 'screens/splash/splash_screen.dart'; // Startpunkt
import 'screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // (Optional) Firestore offline deaktivieren
    await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    await _checkFirestoreConnection();

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('❌ Fehler bei Firebase-Init: $e');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const ErrorApp());
  }
}

/// 🔍 Prüft, ob Firestore erreichbar ist
Future<void> _checkFirestoreConnection() async {
  try {
    final result = await FirebaseFirestore.instance
        .collection('test_connection')
        .limit(1)
        .get(const GetOptions(source: Source.server));
    debugPrint('✅ Firestore ist online. Dokumente: ${result.docs.length}');
  } catch (e) {
    debugPrint('❌ Firestore NICHT erreichbar: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => myAuth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aufgabenverwaltung',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(), // Startet mit Splash
        routes: appRoutes,
        onGenerateRoute: _generateRoute,
        builder: (context, child) => MediaQuery.withNoTextScaling(child: child!),
      ),
    );
  }

  /// ✏️ Dynamische Routen (z. B. mit Argumenten)
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/create':
        final dateArg = settings.arguments as DateTime?;
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(dateArg: dateArg),
        );
      case '/calendar':
        return MaterialPageRoute(
          builder: (_) => const CalendarScreen(),
        );
      default:
        final builder = appRoutes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        return _notFoundRoute();
    }
  }

  Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text(
            '404 – Seite nicht gefunden',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '❌ Fehler beim Initialisieren der App.\nBitte später erneut versuchen.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
