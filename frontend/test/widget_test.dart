import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  test('LocalMind application can be constructed', () {
    const app = LocalMindApp();

    expect(app, isA<LocalMindApp>());
  });
}