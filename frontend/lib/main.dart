import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const LocalMindApp());
}

class LocalMindApp extends StatelessWidget {
  const LocalMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3559E0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Dio _dio = Dio();

  bool _checkingBackend = true;
  bool _backendConnected = false;
  String _statusMessage = 'Checking LocalMind backend...';

  @override
  void initState() {
    super.initState();
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    setState(() {
      _checkingBackend = true;
      _statusMessage = 'Checking LocalMind backend...';
    });

    try {
      final response = await _dio.get(
        'http://127.0.0.1:8000/api/health',
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data is Map &&
          data['status'] == 'healthy') {
        setState(() {
          _backendConnected = true;
          _statusMessage = 'Backend connected';
          _checkingBackend = false;
        });

        return;
      }

      setState(() {
        _backendConnected = false;
        _statusMessage = 'Backend returned an unexpected response';
        _checkingBackend = false;
      });
    } catch (error) {
      setState(() {
        _backendConnected = false;
        _statusMessage = 'Backend unavailable';
        _checkingBackend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildWelcomeCard(),
                  const SizedBox(height: 24),
                  _buildBackendStatusCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF3559E0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.psychology_alt_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LocalMind',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Offline AI Learning',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your learning workspace',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Import books, study chapter-by-chapter, complete quizzes, '
            'and track your progress completely locally.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackendStatusCard() {
    final Color statusColor;

    if (_checkingBackend) {
      statusColor = Colors.orange;
    } else if (_backendConnected) {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.red;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          if (_checkingBackend)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            )
          else
            Icon(
              _backendConnected
                  ? Icons.check_circle_outline
                  : Icons.error_outline,
              color: statusColor,
              size: 26,
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Local backend',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          if (!_checkingBackend)
            TextButton.icon(
              onPressed: _checkBackend,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}