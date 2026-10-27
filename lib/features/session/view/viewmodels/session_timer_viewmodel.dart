import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/source/session_remote_source.dart';

enum TimerStatus { initial, running, paused, completed }

/// ViewModel untuk Active Deep Focus Session & Timer
class SessionTimerViewModel extends ChangeNotifier {
  final SessionRemoteSource? _remoteSource;

  int _totalSeconds = 25 * 60; // 25 Menit default Pomodoro
  int _remainingSeconds = 25 * 60;
  TimerStatus _status = TimerStatus.initial;
  Timer? _ticker;
  bool _isGhostMode = false;
  String _sessionTitle = 'Deep Focus Session: Algoritma & Struktur Data';
  final String _currentSpotName = 'Main Campus Library';

  final List<StudyBuddy> _activeBuddies = [
    MockData.buddies[0],
    MockData.buddies[1],
    MockData.buddies[3],
  ];

  SessionTimerViewModel({SessionRemoteSource? remoteSource})
      : _remoteSource = remoteSource;

  SessionRemoteSource? get remoteSource => _remoteSource;

  int get totalSeconds => _totalSeconds;
  int get remainingSeconds => _remainingSeconds;
  TimerStatus get status => _status;
  bool get isRunning => _status == TimerStatus.running;
  bool get isGhostMode => _isGhostMode;
  String get sessionTitle => _sessionTitle;
  String get currentSpotName => _currentSpotName;
  List<StudyBuddy> get activeBuddies => _activeBuddies;

  double get progressRatio {
    if (_totalSeconds <= 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setDurationMinutes(int minutes) {
    if (_status == TimerStatus.running) return;
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _status = TimerStatus.initial;
    notifyListeners();
  }

  void start() {
    if (_status == TimerStatus.running) return;

    _status = TimerStatus.running;
    notifyListeners();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _status = TimerStatus.completed;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void pause() {
    if (_status == TimerStatus.running) {
      _ticker?.cancel();
      _status = TimerStatus.paused;
      notifyListeners();
    }
  }

  void resume() {
    if (_status == TimerStatus.paused) {
      start();
    }
  }

  void reset() {
    _ticker?.cancel();
    _remainingSeconds = _totalSeconds;
    _status = TimerStatus.initial;
    notifyListeners();
  }

  void toggleGhostMode() {
    _isGhostMode = !_isGhostMode;
    notifyListeners();
  }

  void updateSessionTitle(String title) {
    _sessionTitle = title;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

/// Alias typedef untuk kompatibilitas impor lama
typedef SessionTimerProvider = SessionTimerViewModel;
