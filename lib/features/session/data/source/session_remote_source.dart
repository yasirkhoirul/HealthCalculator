import '../models/session_model.dart';

/// Remote Data Source untuk sesi belajar fokus (Session)
class SessionRemoteSource {
  Future<SessionModel> getActiveSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const SessionModel(
      id: 'session-1',
      title: 'Deep Focus Session: Algoritma & Struktur Data',
      spotName: 'Main Campus Library',
      durationMinutes: 25,
      remainingSeconds: 25 * 60,
      isRunning: false,
    );
  }
}
