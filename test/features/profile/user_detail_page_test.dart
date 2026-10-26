import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/profile/view/pages/user_detail_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/profile/view/widgets/user_action_button_widget.dart';
import 'package:health_calculator/features/session/view/viewmodels/session_timer_provider.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<ProfileViewModel>()) {
      setupLocator();
    }
  });

  Widget buildTestWidget({
    required String userId,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ChangeNotifierProvider.value(value: locator<FriendsProvider>()),
        ChangeNotifierProvider.value(value: locator<StudyMapProvider>()),
        ChangeNotifierProvider.value(value: locator<SessionTimerProvider>()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: UserDetailPage(userId: userId),
      ),
    );
  }

  group('UserDetailPage Widget Tests', () {
    testWidgets('Renders student profile header, stats, bio, interests, and action buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1'));
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsOneWidget);
      expect(find.text('Alif Fathur R.'), findsOneWidget);
      expect(find.text('Profil Mahasiswa'), findsOneWidget);
      expect(find.byType(UserActionButtonWidget), findsOneWidget);

      // Verify study statistics
      expect(find.text('Total Belajar'), findsOneWidget);
      expect(find.text('Sesi Selesai'), findsOneWidget);
      expect(find.text('Study Buddy'), findsOneWidget);

      // Verify bio & radar
      expect(find.text('Bio & Status Belajar'), findsOneWidget);
      expect(find.text('Terlihat aktif di radar peta kampus'), findsOneWidget);

      // Scroll down to see interests
      await tester.scrollUntilVisible(
        find.text('Minat & Topik Belajar'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Minat & Topik Belajar'), findsOneWidget);
      expect(find.text('Flutter Mobile Dev'), findsOneWidget);
    });

    testWidgets('Shows dynamic friendship status and toggles state', (tester) async {
      // buddy-5 starts with 'none'
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-5'));
      await tester.pumpAndSettle();

      // Initial state: not friends
      expect(find.text('+ Tambah Teman'), findsOneWidget);

      // Tap + Tambah Teman -> changes to pending
      await tester.tap(find.text('+ Tambah Teman'));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Permintaan Terkirim'), findsOneWidget);
    });

    testWidgets('Ajak Belajar Bareng opens knock request bottom sheet', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1'));
      await tester.pumpAndSettle();

      final knockBtn = find.text('Ajak Belajar Bareng (Knock Request)');
      expect(knockBtn, findsOneWidget);

      await tester.tap(knockBtn);
      await tester.pumpAndSettle();

      // Bottom sheet content
      expect(find.text('Kirim knock notifikasi langsung ke Alif Fathur R.'), findsOneWidget);
      expect(find.text('Kirim Permintaan Belajar'), findsOneWidget);

      // Tap send invite
      await tester.tap(find.text('Kirim Permintaan Belajar'));
      await tester.pumpAndSettle();

      expect(find.text('Knock request berhasil dikirim ke Alif Fathur R.!'), findsOneWidget);
    });

    testWidgets('Renders without error in Dark Mode', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1', themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsOneWidget);
      expect(find.text('Alif Fathur R.'), findsOneWidget);
    });
  });
}
