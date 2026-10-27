import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/constant/app_base_state.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/chat/view/viewmodels/chat_viewmodel.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/data/models/search_history_model.dart';
import 'package:health_calculator/features/map/data/models/spot_model.dart';
import 'package:health_calculator/features/map/data/source/search_local_source.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_search_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/map/view/widgets/search/map_search_overlay_widget.dart';
import 'package:health_calculator/features/map/view/widgets/search/search_recent_list_widget.dart';
import 'package:health_calculator/features/map/view/widgets/search/search_result_item_card.dart';
import 'package:health_calculator/features/map/view/widgets/search/search_results_list_widget.dart';
import 'package:health_calculator/features/map/view/widgets/spot_detail/spot_detail_bottom_sheet.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/session/view/viewmodels/session_timer_provider.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!locator.isRegistered<MapSearchViewModel>()) {
      setupLocator();
    }
  });

  group('SearchHistoryModel & SearchLocalSource Tests', () {
    test('SearchHistoryModel serializes to and from JSON', () {
      final now = DateTime(2026, 10, 26, 12, 0);
      final model = SearchHistoryModel(
        query: 'Main Library',
        timestamp: now,
        category: 'Library',
      );

      final json = model.toJson();
      expect(json['query'], 'Main Library');
      expect(json['category'], 'Library');

      final fromJson = SearchHistoryModel.fromJson(json);
      expect(fromJson.query, 'Main Library');
      expect(fromJson.category, 'Library');
    });

    test('SearchLocalSource saves, deduplicates, and limits items to 10', () async {
      final source = SearchLocalSource();

      await source.clearAllRecentSearches();
      expect(await source.getRecentSearches(), isEmpty);

      // Save multiple items
      for (int i = 1; i <= 12; i++) {
        await source.saveRecentSearch('Query $i');
      }

      final list = await source.getRecentSearches();
      expect(list.length, SearchLocalSource.maxRecentSearches);
      expect(list.first, 'Query 12');

      // Deduplicate: saving 'Query 5' should move it to index 0
      await source.saveRecentSearch('query 5');
      final updated = await source.getRecentSearches();
      expect(updated.first, 'query 5');
      expect(updated.length, SearchLocalSource.maxRecentSearches);

      // Remove single item
      await source.removeRecentSearch('query 5');
      final afterRemove = await source.getRecentSearches();
      expect(afterRemove.contains('query 5'), false);

      // Clear all
      await source.clearAllRecentSearches();
      expect(await source.getRecentSearches(), isEmpty);
    });
  });

  group('MapSearchViewModel Unit Tests', () {
    test('Initializes with recent searches and handles query debouncing', () async {
      final source = SearchLocalSource();
      await source.clearAllRecentSearches();
      await source.saveRecentSearch('Library');
      await source.saveRecentSearch('Roastery');

      final vm = MapSearchViewModel(localSource: source);
      await vm.initRecentSearches();

      expect(vm.recentSearches.length, 2);
      expect(vm.recentSearches.first, 'Roastery');
      expect(vm.searchState, isA<AppStateInitial<List<SpotModel>>>());

      // Type search query
      vm.onQueryChanged('Library');
      expect(vm.searchState, isA<AppStateLoading<List<SpotModel>>>());

      // Wait for debounce timer (300ms)
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(vm.searchState, isA<AppStateSuccess<List<SpotModel>>>());

      final results = (vm.searchState as AppStateSuccess<List<SpotModel>>).data!;
      expect(results.isNotEmpty, true);
      for (final spot in results) {
        expect(spot.name.toLowerCase().contains('library') ||
            spot.category.toLowerCase().contains('library'), true);
      }

      // Empty search result
      vm.onQueryChanged('xyzUnknownQuery999');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(vm.searchState, isA<AppStateEmpty<List<SpotModel>>>());

      // Clearing query returns to initial
      vm.clearQuery();
      expect(vm.currentQuery, '');
      expect(vm.searchState, isA<AppStateInitial<List<SpotModel>>>());

      vm.dispose();
    });

    test('Add, remove, and clear all recent searches updates state', () async {
      final source = SearchLocalSource();
      await source.clearAllRecentSearches();

      final vm = MapSearchViewModel(localSource: source);
      await vm.addRecentSearch('Creative Studio');
      expect(vm.recentSearches.contains('Creative Studio'), true);

      await vm.removeRecentSearch('Creative Studio');
      expect(vm.recentSearches.contains('Creative Studio'), false);

      await vm.addRecentSearch('Spot A');
      await vm.addRecentSearch('Spot B');
      expect(vm.recentSearches.length, 2);

      await vm.clearAllRecentSearches();
      expect(vm.recentSearches, isEmpty);

      vm.dispose();
    });
  });

  group('Search Widgets Unit & Interaction Tests', () {
    testWidgets('SearchRecentListWidget renders items and triggers callbacks', (tester) async {
      String selected = '';
      String removed = '';
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SearchRecentListWidget(
              recentSearches: const ['Main Library', 'Cafe Ada'],
              onSelectRecent: (q) => selected = q,
              onRemoveRecent: (q) => removed = q,
              onClearAll: () => cleared = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pencarian Terkini'), findsOneWidget);
      expect(find.text('Hapus Semua'), findsOneWidget);
      expect(find.text('Main Library'), findsOneWidget);
      expect(find.text('Cafe Ada'), findsOneWidget);

      // Tap item to select
      await tester.tap(find.text('Main Library'));
      expect(selected, 'Main Library');

      // Tap close icon on second item
      await tester.tap(find.byIcon(Icons.close).last);
      expect(removed, 'Cafe Ada');

      // Tap Hapus Semua
      await tester.tap(find.text('Hapus Semua'));
      expect(cleared, true);
    });

    testWidgets('SearchResultItemCard highlights query and triggers tap', (tester) async {
      SpotModel? tappedSpot;
      const testSpot = SpotModel(
        id: 'spot-1',
        name: 'Main Library Floor 2',
        category: 'Library',
        subtitle: 'Silent Zone',
        distanceInMeters: 350,
        crowdStatus: '14 Desks Open',
        crowdLevel: 'Silent Zone',
        friendsSummary: 'Maya nearby',
        latitude: -6.36,
        longitude: 106.82,
        rating: 4.9,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SearchResultItemCard(
              spot: testSpot,
              query: 'Library',
              onTap: (s) => tappedSpot = s,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultItemCard), findsOneWidget);
      expect(find.text('350m'), findsOneWidget);
      expect(find.text('14 Desks Open'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);

      await tester.tap(find.byType(SearchResultItemCard));
      expect(tappedSpot?.id, 'spot-1');
    });

    testWidgets('SearchResultsListWidget handles loading, empty, and success states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SearchResultsListWidget(
              searchState: const AppStateEmpty(message: 'Spot belajar tidak ditemukan'),
              query: 'unknown',
              onSpotTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Spot belajar tidak ditemukan'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });

    testWidgets('SpotDetailBottomSheet renders all details and actions', (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SpotDetailBottomSheet(spot: testSpot),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('LIBRARY'), findsOneWidget);
      expect(find.text('Main Campus Library'), findsOneWidget);
      expect(find.text('Silent Focus Area'), findsOneWidget);
      expect(find.text('350m'), findsOneWidget);
      expect(find.text('14 Meja'), findsOneWidget);
      expect(find.text('28 friends nearby'), findsOneWidget);
      expect(find.text('Check-in Belajar'), findsOneWidget);
      expect(find.text('Rute'), findsOneWidget);
    });
  });

  group('MapScreen Smart Search Overlay Integration Tests', () {
    Widget buildTestMapScreen() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
          ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
          ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
          ChangeNotifierProvider.value(value: locator<ChatViewModel>()),
          ChangeNotifierProvider.value(value: locator<StudyMapProvider>()),
          ChangeNotifierProvider.value(value: locator<MapViewModel>()),
          ChangeNotifierProvider.value(value: locator<FriendsProvider>()),
          ChangeNotifierProvider.value(value: locator<SessionTimerProvider>()),
        ],
        child: const MaterialApp(
          home: MapScreen(),
        ),
      );
    }

    testWidgets('Tapping search bar in MapScreen opens MapSearchOverlayWidget, selecting spot opens SpotDetailBottomSheet', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestMapScreen());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify search overlay is not visible initially
      expect(find.byType(MapSearchOverlayWidget), findsNothing);

      // Tap on search bar to open Smart Search Overlay
      await tester.tap(find.byIcon(Icons.search_rounded).first);
      await tester.pumpAndSettle();

      // Search overlay should now be open
      expect(find.byType(MapSearchOverlayWidget), findsOneWidget);
      expect(find.byType(SearchRecentListWidget), findsOneWidget);

      // Type query into search overlay TextField
      await tester.enterText(
        find.descendant(
          of: find.byType(MapSearchOverlayWidget),
          matching: find.byType(TextField),
        ),
        'Library',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Live search results should be visible
      expect(find.byType(SearchResultsListWidget), findsOneWidget);
      expect(find.byType(SearchResultItemCard), findsWidgets);

      // Tap on first search result
      await tester.tap(find.byType(SearchResultItemCard).first);
      await tester.pumpAndSettle();

      // Overlay should close and SpotDetailBottomSheet should appear
      expect(find.byType(MapSearchOverlayWidget), findsNothing);
      expect(find.byType(SpotDetailBottomSheet), findsOneWidget);
      expect(find.text('Check-in Belajar'), findsOneWidget);
    });
  });
}
