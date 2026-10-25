import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ViewModel untuk mengelola preferensi Tema Aplikasi (Dark Mode / Light Mode / Ikuti Sistem).
class ThemeViewModel extends ChangeNotifier {
  static const String _prefKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeViewModel() {
    loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  /// Apakah tema sedang disetel mengikuti sistem / perangkat pengguna
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Alias untuk isSystemMode
  bool get isSystem => isSystemMode;

  /// Apakah tema sedang disetel ke mode terang manual
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Apakah tema sedang disetel ke mode gelap manual
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Label teks dari mode tema aktif
  String get currentThemeLabel {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'Sistem';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
    }
  }

  /// Mengubah mode tema dan menyimpannya ke penyimpanan lokal (SharedPreferences)
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String value;
      switch (mode) {
        case ThemeMode.system:
          value = 'system';
          break;
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.dark:
          value = 'dark';
          break;
      }
      await prefs.setString(_prefKey, value);
    } catch (_) {
      // SharedPreferences failure shouldn't break UI state
    }
  }

  /// Memuat preferensi tema yang tersimpan
  Future<void> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getString(_prefKey);
      if (savedValue != null) {
        switch (savedValue) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
          default:
            _themeMode = ThemeMode.system;
            break;
        }
        notifyListeners();
      }
    } catch (_) {
      // Use default ThemeMode.system
    }
  }
}
