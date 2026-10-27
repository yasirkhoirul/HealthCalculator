import 'package:flutter/foundation.dart';

/// Provider untuk mengelola status navigasi global dan lencana (badge) notifikasi
class NavigationProvider extends ChangeNotifier {
  int _currentTabIndex = 0;
  int _unreadRequestsCount = 2;
  bool _isSessionActive = false;

  int get currentTabIndex => _currentTabIndex;
  int get unreadRequestsCount => _unreadRequestsCount;
  bool get isSessionActive => _isSessionActive;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void setSessionActive(bool active) {
    _isSessionActive = active;
    notifyListeners();
  }

  void decrementUnreadRequests() {
    if (_unreadRequestsCount > 0) {
      _unreadRequestsCount--;
      notifyListeners();
    }
  }

  void resetUnreadRequests() {
    _unreadRequestsCount = 0;
    notifyListeners();
  }
}
