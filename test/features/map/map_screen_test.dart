import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/mock/mock_data.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
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

  testWidgets('Close (X) button closes bottom sheet and resets selectedSpot to null', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    // Initially, bottom sheet is open with the first spot
    expect(provider.selectedSpot, isNotNull);
    expect(provider.isBottomSheetOpen, isTrue);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tap the close 'x' button
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Verify bottom sheet is closed and selectedSpot is null
    expect(provider.isBottomSheetOpen, isFalse);
    expect(provider.selectedSpot, isNull);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('Tapping on a marker opens bottom sheet and tapping again toggles it closed', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    // Close the sheet first
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(provider.selectedSpot, isNull);

    // Tap the first spot marker pin (find by spot name)
    final firstSpotName = MockData.spots.first.name;
    final spotPin = find.text(firstSpotName);
    expect(spotPin, findsOneWidget);

    await tester.tap(spotPin);
    await tester.pumpAndSettle();

    // Verify it is open and selected
    expect(provider.isBottomSheetOpen, isTrue);
    expect(provider.selectedSpot?.name, firstSpotName);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tap the same spot pin again -> toggles it closed
    await tester.tap(find.text(firstSpotName).first);
    await tester.pumpAndSettle();

    expect(provider.isBottomSheetOpen, isFalse);
    expect(provider.selectedSpot, isNull);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('Tapping on map canvas background dismisses the bottom sheet', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider));
    await tester.pumpAndSettle();

    expect(provider.isBottomSheetOpen, isTrue);

    // Tap at top area of the map canvas (below search bar, outside any pins)
    await tester.tapAt(const Offset(50, 200));
    await tester.pumpAndSettle();

    // Verify bottom sheet is closed and selectedSpot is reset
    expect(provider.isBottomSheetOpen, isFalse);
    expect(provider.selectedSpot, isNull);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('Close (X) button works reliably in Dark Mode', (tester) async {
    final provider = StudyMapProvider();
    await tester.pumpWidget(buildTestWidget(mapProvider: provider, themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(provider.isBottomSheetOpen, isFalse);
    expect(provider.selectedSpot, isNull);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });
}
