import 'dart:async';

import 'package:flutter/foundation.dart';

class FocusTimerController extends ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _elapsedSeconds = 0;
  bool _running = false;
  DateTime? _startedAt;

  int get remainingSeconds => _remainingSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  bool get running => _running;
  DateTime? get startedAt => _startedAt;

  void start(int minutes) {
    if (_running) return;
    if (_remainingSeconds == 0) _remainingSeconds = minutes * 60;
    _startedAt ??= DateTime.now();
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      if (_remainingSeconds > 0) _remainingSeconds--;
      if (_remainingSeconds == 0) stop();
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = 0;
    _elapsedSeconds = 0;
    _running = false;
    _startedAt = null;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
