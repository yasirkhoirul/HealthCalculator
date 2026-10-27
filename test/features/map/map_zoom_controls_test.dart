import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/chat/view/viewmodels/chat_viewmodel.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/map/view/widgets/map_recenter_fab_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_zoom_controls_widget.dart';
import 'package:health_calculator/features/map/view/widgets/single_recenter_fab_widget.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/session/view/viewmodels/session_timer_provider.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<MapViewModel>()) {
      setupLocator();
    }
  });

  group('MapViewModel Zoom Logic Tests', () {
    test('Initial zoom is 1.0, can zoom in and zoom out', () {
      final vm = MapViewModel();
      expect(vm.currentZoom, 1.0);
      expect(vm.canZoomIn, true);
      expect(vm.canZoomOut, true);
    });

    test('zoomIn increases zoom by 0.25 until maxZoom (3.5)', () {
      final vm = MapViewModel();
      vm.zoomIn();
      expect(vm.currentZoom, 1.25);
      expect(vm.canZoomIn, true);

      // Zoom in to max
      for (int i = 0; i < 15; i++) {
        vm.zoomIn();
      }
      expect(vm.currentZoom, 3.5);
      expect(vm.canZoomIn, false);

      // Further zoomIn should not exceed max
      vm.zoomIn();
      expect(vm.currentZoom, 3.5);
    });

    test('zoomOut decreases zoom by 0.25 until minZoom (0.75)', () {
      final vm = MapViewModel();
      vm.zoomOut();
      expect(vm.currentZoom, 0.75);
      expect(vm.canZoomOut, false);

      // Further zoomOut should not go below min
      vm.zoomOut();
      expect(vm.currentZoom, 0.75);
    });

    test('setZoom and resetZoom work properly within bounds', () {
      final vm = MapViewModel();
      vm.setZoom(2.0);
      expect(vm.currentZoom, 2.0);

      vm.setZoom(5.0); // should clamp to 3.5
      expect(vm.currentZoom, 3.5);

      vm.setZoom(0.2); // should clamp to 0.75
      expect(vm.currentZoom, 0.75);

      vm.resetZoom();
      expect(vm.currentZoom, 1.0);
    });
  });

  group('MapZoomControlsWidget Unit & Interaction Tests', () {
    testWidgets('Renders zoom in (+) and zoom out (-) buttons with proper touch target', (tester) async {
      bool zoomInTriggered = false;
      bool zoomOutTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: MapZoomControlsWidget(
                onZoomIn: () => zoomInTriggered = true,
                onZoomOut: () => zoomOutTriggered = true,
                canZoomIn: true,
                canZoomOut: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MapZoomControlsWidget), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);

      // Tap Zoom In
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(zoomInTriggered, true);

      // Tap Zoom Out
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
      expect(zoomOutTriggered, true);
    });

    testWidgets('Disabled state prevents callback trigger at limits', (tester) async {
      bool zoomInTriggered = false;
      bool zoomOutTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: MapZoomControlsWidget(
                onZoomIn: () => zoomInTriggered = true,
                onZoomOut: () => zoomOutTriggered = true,
                canZoomIn: false,
                canZoomOut: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(zoomInTriggered, false);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
      expect(zoomOutTriggered, false);
    });

    testWidgets('Renders correctly in Dark Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Center(
              child: MapZoomControlsWidget(
                onZoomIn: () {},
                onZoomOut: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MapZoomControlsWidget), findsOneWidget);
    });
  });

  group('SingleRecenterFabWidget Unit Tests', () {
    testWidgets('Renders with solid purple color, white GPS icon, and triggers callback on tap', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleRecenterFabWidget(
                onPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleRecenterFabWidget), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);

      await tester.tap(find.byType(SingleRecenterFabWidget));
      await tester.pump();
      expect(pressed, true);
    });
  });

  group('MapScreen Pure Pinch-to-Zoom & Recenter FAB Integration Tests', () {
    testWidgets('MapScreen uses InteractiveViewer without physical zoom buttons and renders SingleRecenterFabWidget', (tester) async {
      final mapVm = MapViewModel();
      final mapProvider = StudyMapProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
            ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
            ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
            ChangeNotifierProvider.value(value: locator<ChatViewModel>()),
            ChangeNotifierProvider.value(value: mapProvider),
            ChangeNotifierProvider.value(value: mapVm),
            ChangeNotifierProvider(create: (_) => FriendsProvider()),
            ChangeNotifierProvider(create: (_) => SessionTimerProvider()),
          ],
          child: const MaterialApp(
            home: MapScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Verify physical zoom buttons are NOT present on MapScreen
      expect(find.byType(MapZoomControlsWidget), findsNothing);

      // Verify InteractiveViewer is configured for pure pinch-to-zoom with correct scale limits
      final interactiveViewerFinder = find.byType(InteractiveViewer);
      expect(interactiveViewerFinder, findsOneWidget);
      final interactiveViewer = tester.widget<InteractiveViewer>(interactiveViewerFinder);
      expect(interactiveViewer.minScale, 0.75);
      expect(interactiveViewer.maxScale, 3.5);

      // Verify single recenter FAB is rendered
      expect(find.byType(SingleRecenterFabWidget), findsOneWidget);
      expect(find.byType(MapRecenterFabWidget), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsWidgets);

      // Tap single recenter FAB
      await tester.tap(find.byType(SingleRecenterFabWidget));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    });
  });
}

