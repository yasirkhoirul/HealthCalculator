import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/mock/mock_data.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/map/view/widgets/map_spot_marker_widget.dart';
import 'package:health_calculator/features/map/view/widgets/spot_detail/spot_detail_bottom_sheet.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
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
    StudyMapProvider? mapProvider,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => mapProvider ?? StudyMapProvider()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => SessionTimerProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const MapScreen(),
      ),
    );
  }

  testWidgets('Tapping on a spot pin marker opens SpotDetailBottomSheet (Single Source of Truth)', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    // Tap the first spot marker pin (find by spot name on MapSpotMarkerWidget)
    final firstSpotName = MockData.spots.first.name;
    final spotPin = find.descendant(
      of: find.byType(MapSpotMarkerWidget),
      matching: find.text(firstSpotName),
    );
    expect(spotPin, findsOneWidget);

    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    // Verify modal SpotDetailBottomSheet is displayed
    expect(find.byType(SpotDetailBottomSheet), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(provider.selectedSpot?.name, firstSpotName);

    // Tap close (X) button inside SpotDetailBottomSheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Verify bottom sheet is dismissed and selectedSpot is reset to null
    expect(find.byType(SpotDetailBottomSheet), findsNothing);
    expect(provider.selectedSpot, isNull);
  });

  testWidgets('Tapping on modal barrier dismisses SpotDetailBottomSheet and resets selectedSpot', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    final firstSpotName = MockData.spots.first.name;
    final spotPin = find.descendant(
      of: find.byType(MapSpotMarkerWidget),
      matching: find.text(firstSpotName),
    );
    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    expect(find.byType(SpotDetailBottomSheet), findsOneWidget);

    // Tap outside at top barrier
    await tester.tapAt(const Offset(50, 40));
    await tester.pumpAndSettle();

    // Verify modal is dismissed and state cleared
    expect(find.byType(SpotDetailBottomSheet), findsNothing);
    expect(provider.selectedSpot, isNull);
  });

  testWidgets('Close (X) button on SpotDetailBottomSheet works reliably in Dark Mode', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider, themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();

    final firstSpotName = MockData.spots.first.name;
    final spotPin = find.descendant(
      of: find.byType(MapSpotMarkerWidget),
      matching: find.text(firstSpotName),
    );
    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    expect(find.byType(SpotDetailBottomSheet), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(SpotDetailBottomSheet), findsNothing);
    expect(provider.selectedSpot, isNull);
  });

  testWidgets('Persistent Bottom Sheet with Top Campus Spots and View map list remains visible when tapping canvas or closing spot detail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    // Verify persistent bottom sheet elements are visible initially
    expect(find.text('Top Campus Spots'), findsOneWidget);
    expect(find.text('View map list'), findsOneWidget);
    expect(find.text('Lokasi Sekarang'), findsOneWidget);
    expect(find.text('Pusatkan'), findsOneWidget);

    // Tap on the map canvas outside the bottom sheet
    await tester.tapAt(const Offset(200, 300));
    await tester.pumpAndSettle();

    // The persistent bottom sheet MUST STILL BE VISIBLE!
    expect(find.text('Top Campus Spots'), findsOneWidget);
    expect(find.text('View map list'), findsOneWidget);
    expect(find.text('Lokasi Sekarang'), findsOneWidget);

    // Tap a spot marker to open modal detail
    final firstSpotName = MockData.spots.first.name;
    final spotPin = find.descendant(
      of: find.byType(MapSpotMarkerWidget),
      matching: find.text(firstSpotName),
    );
    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    expect(find.byType(SpotDetailBottomSheet), findsOneWidget);

    // Close the spot detail modal
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Spot detail is closed, and persistent bottom sheet remains completely intact
    expect(find.byType(SpotDetailBottomSheet), findsNothing);
    expect(find.text('Top Campus Spots'), findsOneWidget);
    expect(find.text('View map list'), findsOneWidget);
    expect(find.text('Lokasi Sekarang'), findsOneWidget);
  });
}
