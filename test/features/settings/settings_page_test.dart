import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/settings/view/pages/settings_main_page.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:health_calculator/features/settings/view/widgets/lime_switch_widget.dart';
import 'package:health_calculator/features/settings/view/widgets/settings_account_section_widget.dart';
import 'package:health_calculator/features/settings/view/widgets/settings_notification_section_widget.dart';
import 'package:health_calculator/features/settings/view/widgets/settings_privacy_section_widget.dart';
import 'package:health_calculator/features/settings/view/widgets/settings_support_section_widget.dart';
import 'package:health_calculator/features/settings/view/widgets/settings_theme_section_widget.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<ProfileViewModel>()) {
      setupLocator();
    }
  });

  testWidgets('SettingsMainPage renders all widgets and responds to user interaction',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
          ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
          ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ],
        child: const MaterialApp(
          home: SettingsMainPage(),
        ),
      ),
    );

    // 1. Check AppBar
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // 2. Check Theme Section
    expect(find.byType(SettingsThemeSectionWidget), findsOneWidget);
    expect(find.text('TAMPILAN & TEMA'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
    expect(find.text('Terang'), findsOneWidget);
    expect(find.text('Gelap'), findsOneWidget);

    // Test Theme Mode Switch to Dark
    await tester.tap(find.text('Gelap'));
    await tester.pumpAndSettle();
    expect(locator<ThemeViewModel>().themeMode, ThemeMode.dark);

    // Test Theme Mode Switch back to Sistem
    await tester.tap(find.text('Sistem'));
    await tester.pumpAndSettle();
    expect(locator<ThemeViewModel>().themeMode, ThemeMode.system);

    // 2. Check Privacy Section
    expect(find.byType(SettingsPrivacySectionWidget), findsOneWidget);
    expect(find.text('PRIVASI & PELACAKAN LOKASI MAP'), findsOneWidget);
    expect(find.text('Ghost Mode (Sembunyikan dari Peta)'), findsOneWidget);
    expect(find.text('Radius Visibilitas Lokasi'), findsOneWidget);
    expect(find.text('Presisi Tinggi'), findsOneWidget);
    expect(find.text('Tepat'), findsOneWidget);
    expect(find.text('Kampus Saja'), findsOneWidget);
    expect(find.text('Siapa yang Dapat Mengetuk (Knock)'), findsOneWidget);

    // Test Segmented Control Tap
    await tester.tap(find.text('Kampus Saja'));
    await tester.pumpAndSettle();

    // 4. Check Notification Section
    expect(find.byType(SettingsNotificationSectionWidget), findsOneWidget);
    expect(find.text('NOTIFIKASI & PENGINGAT'), findsOneWidget);
    expect(find.text('Sesi Belajar Teman di Sekitar'), findsOneWidget);
    expect(find.text('Pengingat Pomodoro & Istirahat'), findsOneWidget);
    expect(find.text('Suara & Getaran'), findsOneWidget);
    expect(find.text('Lonceng Dingin'), findsOneWidget);

    // Test Switch Toggle
    final switches = find.byType(LimeSwitchWidget);
    expect(switches, findsNWidgets(3));
    await tester.tap(switches.first);
    await tester.pumpAndSettle();

    // 5. Check Account Section
    expect(find.byType(SettingsAccountSectionWidget), findsOneWidget);
    expect(find.text('AKUN & KEAMANAN'), findsOneWidget);
    expect(find.text('Email Kampus\nTerhubung'), findsOneWidget);
    expect(find.text('ahmad.farhan@itb.ac.id'), findsOneWidget);
    expect(find.text('Terverifikasi'), findsOneWidget);
    expect(find.text('Ganti Kata Sandi'), findsOneWidget);
    expect(find.text('Perangkat Terhubung'), findsOneWidget);

    // 6. Check Support Section
    expect(find.byType(SettingsSupportSectionWidget), findsOneWidget);
    expect(find.text('BANTUAN & DUKUNGAN'), findsOneWidget);
    expect(find.text('Pusat Bantuan StudyMap'), findsOneWidget);
    expect(find.text('Laporkan Bug'), findsOneWidget);
    expect(find.text('Tentang StudyMap'), findsOneWidget);
    expect(find.text('v2.4 (Build 842)'), findsOneWidget);
    expect(find.text('Keluar Akun'), findsOneWidget);
    expect(
      find.text('StudyMap • Universitas & Komunitas Belajar Mandiri'),
      findsOneWidget,
    );
  });
}
