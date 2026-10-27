import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/map/data/models/spot_model.dart';
import 'package:health_calculator/features/map/view/pages/top_spots_list_page.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/widgets/map_active_sprint_banner_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_bottom_spots_sheet_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_interactive_pins_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_search_filters_widget.dart';
import 'package:health_calculator/features/map/view/widgets/top_spots/spot_list_card_widget.dart';
import 'package:health_calculator/navigation/view/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    MapViewModel? mapViewModel,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    final content = MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: Scaffold(body: child),
    );

    if (mapViewModel != null) {
      return ChangeNotifierProvider<MapViewModel>.value(
        value: mapViewModel,
        child: content,
      );
    }
    return content;
  }

  group('SpotModel Serialization Tests', () {
    test('toJson and fromJson work symmetrically', () {
      final spot = SpotModel(
        id: 'spot-test-1',
        name: 'Test Spot',
        category: 'Library',
        subtitle: 'Silent zone for tests',
        distanceInMeters: 350,
        crowdStatus: '14 Desks Open',
        crowdLevel: 'Silent Zone',
        friendsSummary: '5 friends nearby',
        friendsCount: 5,
        openDesks: 14,
        totalDesks: 30,
        rating: 4.8,
        latitude: -6.36,
        longitude: 106.82,
        isOpen: true,
        vibe: 'Coding',
      );

      final json = spot.toJson();
      expect(json['id'], 'spot-test-1');
      expect(json['name'], 'Test Spot');
      expect(json['distanceInMeters'], 350);
      expect(json['vibe'], 'Coding');

      final deserialized = SpotModel.fromJson(json);
      expect(deserialized.id, spot.id);
      expect(deserialized.name, spot.name);
      expect(deserialized.distanceInMeters, 350);
      expect(deserialized.formattedDistance, '350m');
    });

    test('formattedDistance formats meters and kilometers properly', () {
      const spotNear = SpotModel(
        id: 's1',
        name: 'Near',
        category: 'Cafe',
        subtitle: 'Sub',
        distanceInMeters: 450,
        crowdStatus: 'Quiet',
        crowdLevel: 'Low',
        friendsSummary: '0 friends',
        latitude: 0,
        longitude: 0,
      );
      expect(spotNear.formattedDistance, '450m');

      const spotFar = SpotModel(
        id: 's2',
        name: 'Far',
        category: 'Cafe',
        subtitle: 'Sub',
        distanceInMeters: 1500,
        crowdStatus: 'Quiet',
        crowdLevel: 'Low',
        friendsSummary: '0 friends',
        latitude: 0,
        longitude: 0,
      );
      expect(spotFar.formattedDistance, '1.5km');
    });
  });

  group('MapViewModel Spot Filtering and Sorting Tests', () {
    test('Sorting by nearest orders by distance ascending', () {
      final vm = MapViewModel();
      vm.setSortBy('nearest');

      final spots = vm.spots;
      expect(spots.isNotEmpty, true);
      for (int i = 0; i < spots.length - 1; i++) {
        expect(spots[i].distanceInMeters <= spots[i + 1].distanceInMeters, true);
      }
    });

    test('Sorting by relevant orders by popularity score descending', () {
      final vm = MapViewModel();
      vm.setSortBy('relevant');

      final spots = vm.spots;
      expect(spots.isNotEmpty, true);
      for (int i = 0; i < spots.length - 1; i++) {
        final scoreA = (spots[i].rating * 10) + spots[i].friendsCount;
        final scoreB = (spots[i + 1].rating * 10) + spots[i + 1].friendsCount;
        expect(scoreA >= scoreB, true);
      }
    });

    test('Filtering by vibe filters spots properly', () {
      final vm = MapViewModel();
      vm.setVibe('Coding');

      final codingSpots = vm.spots;
      for (final s in codingSpots) {
        expect(s.vibe.toLowerCase(), 'coding');
      }

      vm.setVibe('All Vibe');
      expect(vm.spots.length >= codingSpots.length, true);
    });

    test('Updating search query filters spots by name and category', () {
      final vm = MapViewModel();
      vm.updateSearchQuery('Library');

      final results = vm.spots;
      expect(results.isNotEmpty, true);
      for (final s in results) {
        final matches = s.name.toLowerCase().contains('library') ||
            s.subtitle.toLowerCase().contains('library') ||
            s.category.toLowerCase().contains('library');
        expect(matches, true);
      }
    });
  });

  group('CustomBottomNavbar Widget Tests', () {
    testWidgets('Renders all 4 navigation items and highlights active index', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        buildTestWidget(
          child: CustomBottomNavbar(
            currentIndex: 0,
            onTap: (idx) => tappedIndex = idx,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavbar), findsOneWidget);
      expect(find.byIcon(Icons.explore_rounded), findsOneWidget);
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Tap on timer icon
      await tester.tap(find.byIcon(Icons.timer_outlined));
      await tester.pump();
      expect(tappedIndex, 1);
    });
  });

  group('MapSearchFiltersWidget Tests', () {
    testWidgets('Renders search input and all vibe filter chips', (tester) async {
      final vm = MapViewModel();

      await tester.pumpWidget(
        buildTestWidget(
          mapViewModel: vm,
          child: MapSearchFiltersWidget(mapViewModel: vm),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Search subject, desk, or study buddy...'), findsOneWidget);
      expect(find.text('All Vibe'), findsOneWidget);
      expect(find.text('Coding'), findsOneWidget);
      expect(find.text('UI/UX'), findsOneWidget);
      expect(find.text('Exam Prep'), findsOneWidget);

      // Tap on Coding chip
      await tester.tap(find.text('Coding'));
      await tester.pumpAndSettle();
      expect(vm.selectedVibe, 'Coding');
    });
  });

  group('Interactive Pin Widgets Tests', () {
    testWidgets('Renders Kotlin pin, Studio Hot pin, and Calculus pin properly', (tester) async {
      bool kotlinTapped = false;
      bool studioTapped = false;
      bool calculusTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: Column(
            children: [
              MapKotlinPinWidget(onTap: () => kotlinTapped = true),
              MapStudioHotPinWidget(onTap: () => studioTapped = true),
              MapCalculusCafePinWidget(onTap: () => calculusTapped = true),
              const MapCompassControlWidget(),
              const MapRightControlsStackWidget(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kotlin • 45m'), findsOneWidget);
      expect(find.text('Studio • 3 buddies'), findsOneWidget);
      expect(find.text('HOT'), findsOneWidget);
      expect(find.text('Calculus • Cafe Ada'), findsOneWidget);
      expect(find.text('N'), findsOneWidget);

      await tester.tap(find.byType(MapKotlinPinWidget));
      await tester.pump();
      expect(kotlinTapped, true);

      await tester.tap(find.byType(MapStudioHotPinWidget));
      await tester.pump();
      expect(studioTapped, true);

      await tester.tap(find.byType(MapCalculusCafePinWidget));
      await tester.pump();
      expect(calculusTapped, true);
    });
  });

  group('MapActiveSprintBannerWidget Tests', () {
    testWidgets('Renders sprint title, subtitle, and responds to Join In tap', (tester) async {
      bool joined = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: MapActiveSprintBannerWidget(
            onJoinTap: () => joined = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CS301 Algorithm Sprint'), findsOneWidget);
      expect(find.text('4 friends joined • Level 3 Silent Room'), findsOneWidget);
      expect(find.text('Join In'), findsOneWidget);

      await tester.tap(find.text('Join In'));
      await tester.pump();
      expect(joined, true);
    });
  });

  group('MapBottomSpotsSheetWidget Tests', () {
    testWidgets('Renders Top Campus Spots header, Live badge, and View map list button', (tester) async {
      bool viewMapListPressed = false;
      final vm = MapViewModel();

      await tester.pumpWidget(
        buildTestWidget(
          mapViewModel: vm,
          child: MapBottomSpotsSheetWidget(
            mapViewModel: vm,
            onViewMapList: () => viewMapListPressed = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Top Campus Spots'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);
      expect(find.text('View map list'), findsOneWidget);

      await tester.tap(find.text('View map list'));
      await tester.pump();
      expect(viewMapListPressed, true);
    });
  });

  group('SpotListCardWidget Tests', () {
    testWidgets('Renders spot card data with distance badge and route button', (tester) async {
      bool cardTapped = false;
      bool routeTapped = false;

      final testSpot = SpotModel.defaultSpots.first;

      await tester.pumpWidget(
        buildTestWidget(
          child: SpotListCardWidget(
            spot: testSpot,
            onTap: () => cardTapped = true,
            onRouteTap: () => routeTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(testSpot.name), findsOneWidget);
      expect(find.text(testSpot.subtitle), findsOneWidget);
      expect(find.text(testSpot.formattedDistance), findsOneWidget);
      expect(find.text(testSpot.crowdStatus), findsOneWidget);

      await tester.tap(find.byType(SpotListCardWidget));
      await tester.pump();
      expect(cardTapped, true);

      await tester.tap(find.byIcon(Icons.navigation_rounded));
      await tester.pump();
      expect(routeTapped, true);
    });
  });

  group('TopSpotsListPage Tests', () {
    testWidgets('Renders Campus Spots AppBar, sorting tabs, and switches sort criteria', (tester) async {
      final vm = MapViewModel();

      await tester.pumpWidget(
        buildTestWidget(
          mapViewModel: vm,
          child: const TopSpotsListPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Campus Spots'), findsOneWidget);
      expect(find.text('Paling Dekat'), findsOneWidget);
      expect(find.text('Paling Relevan'), findsOneWidget);
      expect(find.byType(SpotListCardWidget), findsWidgets);

      // Switch to 'Paling Relevan'
      await tester.tap(find.text('Paling Relevan'));
      await tester.pumpAndSettle();
      expect(vm.sortBy, 'relevant');

      // Switch back to 'Paling Dekat'
      await tester.tap(find.text('Paling Dekat'));
      await tester.pumpAndSettle();
      expect(vm.sortBy, 'nearest');
    });
  });
}
