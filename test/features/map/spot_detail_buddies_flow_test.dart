import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/map/data/models/spot_model.dart';
import 'package:health_calculator/features/map/view/widgets/spot_detail/spot_detail_bottom_sheet.dart';
import 'package:health_calculator/features/profile/view/pages/user_detail_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/user_detail_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<UserDetailViewModel>()) {
      setupLocator();
    }
  });

  const testSpot = SpotModel(
    id: 'spot-1',
    name: 'Main Campus Library',
    category: 'Library',
    subtitle: 'Silent Focus Area',
    distanceInMeters: 350,
    crowdStatus: '14 Desks Open',
    crowdLevel: 'Silent Zone',
    friendsSummary: '28 friends nearby',
    openDesks: 14,
    totalDesks: 60,
    latitude: -6.36,
    longitude: 106.82,
    rating: 4.9,
  );

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: SpotDetailBottomSheet(spot: testSpot),
      ),
    );
  }

  group('SpotDetailBottomSheet Buddies View & Profile Navigation Tests', () {
    testWidgets('Displays options for Ringkasan (3) and Keseluruhan Teman (8)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify header and options
      expect(find.text('Teman Belajar di Lokasi Ini'), findsOneWidget);
      expect(find.text('28 friends nearby'), findsOneWidget);
      expect(find.text('Ringkasan (3)'), findsOneWidget);
      expect(find.text('Keseluruhan Teman (8)'), findsOneWidget);
      expect(
        find.text('Ketuk nama mahasiswa untuk melihat profil lengkap'),
        findsOneWidget,
      );

      // In summary mode, top 3 buddies are visible
      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('Sarah K.'), findsOneWidget);
      expect(find.text('Dimas P.'), findsOneWidget);

      // Other buddies should not be visible in summary mode
      expect(find.text('Nadia S.'), findsNothing);
      expect(find.text('Alif Fathur'), findsNothing);

      // Bottom button to see all is rendered
      expect(
        find.text('Lihat Keseluruhan Teman Belajar (8 Mahasiswa)'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping Keseluruhan Teman option chip expands full buddies list', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on option chip "Keseluruhan Teman (8)"
      await tester.tap(find.byKey(const Key('option_all_buddies_chip')));
      await tester.pumpAndSettle();

      // All 8 buddies should now be present in the widget tree
      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('Sarah K.'), findsOneWidget);
      expect(find.text('Dimas P.'), findsOneWidget);
      expect(find.text('Nadia S.'), findsOneWidget);
      expect(find.text('Alif Fathur'), findsOneWidget);
      expect(find.text('Clara Devina'), findsOneWidget);
      expect(find.text('Kevin Sanjaya'), findsOneWidget);
      expect(find.text('Alya Putri'), findsOneWidget);

      // Bottom button now allows collapsing
      final collapseBtn = find.byKey(const Key('collapse_buddies_bottom_button'));
      await tester.ensureVisible(collapseBtn);
      expect(collapseBtn, findsOneWidget);

      // Tap to collapse
      await tester.tap(collapseBtn);
      await tester.pumpAndSettle();

      // Now back to summary
      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('Nadia S.'), findsNothing);
    });

    testWidgets('Tapping bottom button expands full buddies list', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on bottom button
      final seeAllBtn = find.byKey(const Key('see_all_buddies_bottom_button'));
      await tester.ensureVisible(seeAllBtn);
      await tester.tap(seeAllBtn);
      await tester.pumpAndSettle();

      // All 8 buddies present
      expect(find.text('Nadia S.'), findsOneWidget);
      expect(find.text('Kevin Sanjaya'), findsOneWidget);
    });

    testWidgets('Tapping student name column navigates to UserDetailPage', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on the name column for Rian M. (b-1)
      final buddyNameCol = find.byKey(const Key('buddy_name_col_b-1'));
      await tester.ensureVisible(buddyNameCol);
      await tester.tap(buddyNameCol);
      await tester.pumpAndSettle();

      // UserDetailPage should now be pushed and displayed
      expect(find.byType(UserDetailPage), findsOneWidget);
      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('Profil Mahasiswa'), findsOneWidget);
      expect(find.text('CS UI • Mobile Dev • Universitas Ahmad Dahlan'), findsOneWidget);
    });
  });
}
