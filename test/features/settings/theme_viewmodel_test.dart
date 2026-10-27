import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeViewModel Tests', () {
    test('Initializes with default system mode when no preference saved', () async {
      SharedPreferences.setMockInitialValues({});
      final viewModel = ThemeViewModel();

      expect(viewModel.themeMode, ThemeMode.system);
      expect(viewModel.isSystem, isTrue);
      expect(viewModel.isSystemMode, isTrue);
      expect(viewModel.currentThemeLabel, 'Sistem');
    });

    test('Initializes with dark mode when saved preference is dark', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final viewModel = ThemeViewModel();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.isDarkMode, isTrue);
      expect(viewModel.isSystem, isFalse);
      expect(viewModel.currentThemeLabel, 'Gelap');
    });

    test('Initializes with light mode when saved preference is light', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
      final viewModel = ThemeViewModel();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.themeMode, ThemeMode.light);
      expect(viewModel.isLightMode, isTrue);
      expect(viewModel.isSystem, isFalse);
      expect(viewModel.currentThemeLabel, 'Terang');
    });

    test('setThemeMode updates themeMode and saves to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final viewModel = ThemeViewModel();

      await viewModel.setThemeMode(ThemeMode.dark);
      expect(viewModel.themeMode, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'dark');

      await viewModel.setThemeMode(ThemeMode.light);
      expect(viewModel.themeMode, ThemeMode.light);
      expect(prefs.getString('app_theme_mode'), 'light');

      await viewModel.setThemeMode(ThemeMode.system);
      expect(viewModel.themeMode, ThemeMode.system);
      expect(prefs.getString('app_theme_mode'), 'system');
    });
  });
}
