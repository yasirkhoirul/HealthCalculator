import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/friends/view/pages/friends_page.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/pages/location_details_page.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/map/view/widgets/map_spot_marker_widget.dart';
import 'package:health_calculator/features/profile/view/pages/profile_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/session/view/pages/session_page.dart';
import 'package:health_calculator/features/session/view/viewmodels/session_timer_provider.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:health_calculator/features/study/view/pages/create_room_page.dart';
import 'package:health_calculator/features/study/view/pages/create_schedule_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<ProfileViewModel>()) {
      setupLocator();
    }
  });

  Widget buildTestApp(Widget child, {ThemeMode mode = ThemeMode.dark}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => StudyMapProvider()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => SessionTimerProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mode,
        home: child,
      ),
    );
  }

  testWidgets('MapScreen renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const MapScreen(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(MapScreen), findsOneWidget);
    expect(find.text('Cari spot belajar...'), findsOneWidget);

    // Tap spot pin marker to open unified SpotDetailBottomSheet
    final spotPin = find.byType(MapSpotMarkerWidget).first;
    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    // Verify bottom sheet is open
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tap on close button
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Verify bottom sheet is closed
    expect(find.byIcon(Icons.close_rounded), findsNothing);

    // Now tap to select spot again
    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    // Verify bottom sheet is open again
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('FriendsPage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const FriendsPage(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(FriendsPage), findsOneWidget);
    expect(find.text('Temukan Rekan Belajar'), findsOneWidget);
  });

  testWidgets('SessionPage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const SessionPage(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(SessionPage), findsOneWidget);
    expect(find.text('Active Session'), findsOneWidget);
  });

  testWidgets('ProfilePage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const ProfilePage(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('LocationDetailsPage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const LocationDetailsPage(id: 'spot-1'), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(LocationDetailsPage), findsOneWidget);
  });

  testWidgets('CreateSchedulePage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const CreateSchedulePage(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(CreateSchedulePage), findsOneWidget);
    expect(find.text('Buat Jadwal Belajar'), findsOneWidget);
  });

  testWidgets('CreateRoomPage renders without error in Dark Mode', (tester) async {
    await tester.pumpWidget(buildTestApp(const CreateRoomPage(), mode: ThemeMode.dark));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(CreateRoomPage), findsOneWidget);
    expect(find.text('Buat Ruang Belajar'), findsOneWidget);
  });
}
