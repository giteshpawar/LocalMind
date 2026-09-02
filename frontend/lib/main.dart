import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const LocalMindApp());
}

class LocalMindApp extends StatefulWidget {
  const LocalMindApp({super.key});

  @override
  State<LocalMindApp> createState() => _LocalMindAppState();
}

class _LocalMindAppState extends State<LocalMindApp> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LoginScreen(
        authService: _authService,
      ),
    );
  }
}