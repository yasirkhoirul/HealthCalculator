import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/features/profile/view/pages/profile_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/profile/view/widgets/profile_header_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/profile_stats_widget.dart';

void main() {
  setUp(() {
    if (!locator.isRegistered<ProfileViewModel>()) {
      setupLocator();
    }
  });

  testWidgets('ProfilePage renders header, stats, bio, interests, and radar visibility',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ],
        child: const MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 1. AppBar checks
    expect(find.text('Profil'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // 2. ProfileHeaderWidget checks
    expect(find.byType(ProfileHeaderWidget), findsOneWidget);
    expect(find.text('Ahmad Farhan'), findsOneWidget);
    expect(find.text('@farhan_study'), findsOneWidget);
    expect(find.text('Institut Teknologi Bandung (ITB)'), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);

    // 3. ProfileStatsWidget checks
    expect(find.byType(ProfileStatsWidget), findsOneWidget);
    expect(find.text('Total Belajar'), findsOneWidget);
    expect(find.text('48 Jam'), findsOneWidget);
    expect(find.text('Bareng Teman'), findsOneWidget);
    expect(find.text('32 Sesi'), findsOneWidget);
    expect(find.text('Study Buddy'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);

    // 4. Bio & Radar Status checks
    expect(find.text('Bio & Status Radar'), findsOneWidget);
    expect(find.textContaining('Perpustakaan Pusat'), findsWidgets);

    // 5. Active Interests chips
    expect(find.text('Topik / Minat Belajar Aktif'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('System Design'), findsOneWidget);
    expect(find.text('Calculus'), findsOneWidget);

    // 6. Map Visibility Radar
    expect(find.text('Radar Kampus Aktif (Radius 2 km)'), findsOneWidget);
  });
}
