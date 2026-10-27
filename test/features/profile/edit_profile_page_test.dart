import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/features/profile/view/pages/edit_profile_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_profile_app_bar_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_profile_header_card_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_profile_stats_row_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_interests_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_student_form_widget.dart';
import 'package:health_calculator/features/profile/view/widgets/edit_profile/edit_profile_visibility_card_widget.dart';

void main() {
  setUp(() {
    if (!locator.isRegistered<ProfileViewModel>()) {
      setupLocator();
    }
  });

  testWidgets('EditProfilePage renders all sections and handles interactions correctly',
      (WidgetTester tester) async {
    // Set larger view to accommodate full scroll view
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: EditProfilePage(),
      ),
    );

    // Initial pump (loading)
    await tester.pump();
    // Finish loading delay (350ms in VM)
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 1. Verify AppBar
    expect(find.byType(EditProfileAppBarWidget), findsOneWidget);
    expect(find.text('StudyMap'), findsOneWidget);
    expect(find.text('Profil & Edit Data'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);

    // 2. Verify Header Card
    expect(find.byType(EditProfileHeaderCardWidget), findsOneWidget);
    expect(find.text('Ahmad Farhan'), findsNWidgets(2)); // in header & name input
    expect(find.textContaining('ITB Kampus Ganesha'), findsOneWidget);
    expect(find.text('Foto Galeri'), findsOneWidget);
    expect(find.text('Ambil Foto'), findsOneWidget);
    expect(find.text('Zenly Avatar'), findsOneWidget);

    // 3. Verify Stats Row
    expect(find.byType(EditProfileStatsRowWidget), findsOneWidget);
    expect(find.text('AKTIVITAS BELAJAR SEMESTER INI'), findsOneWidget);
    expect(find.text('Aktif Sesi'), findsOneWidget);
    expect(find.text('48 Jam'), findsOneWidget);
    expect(find.text('Total Belajar'), findsOneWidget);
    expect(find.text('32 Sesi'), findsOneWidget);
    expect(find.text('Bareng Teman'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('Study Buddy'), findsOneWidget);

    // 4. Verify Student Data Card
    expect(find.byType(EditStudentFormWidget), findsOneWidget);
    expect(find.byType(EditInterestsWidget), findsOneWidget);
    expect(find.text('Tervalidasi SSO'), findsOneWidget);
    expect(find.text('Institut Teknologi Bandung (ITB)'), findsOneWidget);
    expect(find.text('Teknik Informatika • 2023'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('System Design'), findsOneWidget);
    expect(find.text('Calculus'), findsOneWidget);
    expect(find.text('Tambah Minat'), findsOneWidget);

    // 5. Test Bio counter
    expect(find.textContaining('/120'), findsOneWidget);

    // 6. Verify Visibility Card
    expect(find.byType(EditProfileVisibilityCardWidget), findsOneWidget);
    expect(find.text('Visibilitas di Peta Kampus'), findsOneWidget);
    expect(
      find.text('Teman dalam radius 2 km dapat melihat kamu sedang aktif belajar di Perpustakaan Pusat.'),
      findsOneWidget,
    );

    // 7. Verify Bottom Save Button
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    // 8. Test Toggle Switch
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // 9. Test Tap Save Button (Simpan in AppBar)
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    // Complete update duration (650ms)
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    // Expect snackbar feedback
    expect(find.text('Perubahan profil berhasil disimpan!'), findsOneWidget);
  });

  test('ProfileViewModel is synchronized with updated profile data', () async {
    final profileProvider = locator<ProfileViewModel>();
    expect(profileProvider.user.name, 'Ahmad Farhan');
    expect(profileProvider.user.campus, 'Institut Teknologi Bandung (ITB)');
    expect(profileProvider.user.totalFocusHours, 48.0);
    expect(profileProvider.user.completedSessions, 32);
    expect(profileProvider.user.connectedBuddies, 14);

    // Update via ProfileViewModel
    await profileProvider.updateProfile(
      profileProvider.user.copyWith(name: 'Ahmad Farhan Updated'),
    );

    expect(profileProvider.user.name, 'Ahmad Farhan Updated');
  });
}
