import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ToDo App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: HomeScreen(),
    );
}
}
