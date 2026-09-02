import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'models/user.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
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

  bool _loading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      await _authService.restoreSession();

      if (_authService.isAuthenticated) {
        _user = await _authService.getCurrentUser();
      }
    } catch (_) {
      await _authService.logout();
      _user = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _user == null
              ? LoginScreen(
                  authService: _authService,
                )
              : HomeScreen(
                  user: _user!,
                  authService: _authService,
                ),
    );
  }
}