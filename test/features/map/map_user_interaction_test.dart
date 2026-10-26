import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/chat/view/viewmodels/chat_viewmodel.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/data/models/study_status_model.dart';
import 'package:health_calculator/features/map/data/models/user_presence_model.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/features/map/view/widgets/map_my_location_marker_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_recenter_fab_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_status_bubble_widget.dart';
import 'package:health_calculator/features/map/view/widgets/map_status_picker_bottom_sheet.dart';
import 'package:health_calculator/features/map/view/widgets/map_user_detail_bottom_sheet.dart';
import 'package:health_calculator/features/map/view/widgets/map_user_marker_widget.dart';
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

  Widget buildTestWidget({
    required Widget child,
    MapViewModel? mapViewModel,
    StudyMapProvider? mapProvider,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ChangeNotifierProvider.value(value: locator<ChatViewModel>()),
        ChangeNotifierProvider(create: (_) => mapProvider ?? StudyMapProvider()),
        ChangeNotifierProvider(create: (_) => mapViewModel ?? locator<MapViewModel>()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => SessionTimerProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: Scaffold(body: child),
      ),
    );
  }

  group('StudyStatusModel & UserPresenceModel Serialization Tests', () {
    test('StudyStatusModel toJson and fromJson work symmetrically', () {
      final status = StudyStatusModel(
        emoji: '🔥',
        label: 'Semangat',
        customMessage: 'Ngebut deadline skripsi',
        updatedAt: DateTime.parse('2026-10-26T00:00:00Z'),
      );

      final json = status.toJson();
      expect(json['emoji'], '🔥');
      expect(json['label'], 'Semangat');
      expect(json['customMessage'], 'Ngebut deadline skripsi');

      final fromJson = StudyStatusModel.fromJson(json);
      expect(fromJson.emoji, '🔥');
      expect(fromJson.displayText, 'Ngebut deadline skripsi');
      expect(StudyStatusModel.presets.length, 5);
    });

    test('UserPresenceModel toJson and fromJson work symmetrically with status', () {
      final user = UserPresenceModel(
        id: 'u-rian',
        name: 'Rian M.',
        campus: 'Universitas Indonesia',
        major: 'Mobile App Dev (Android)',
        currentSpotName: 'Perpustakaan Pusat',
        currentTopic: 'Python Dev',
        latitude: -6.3625,
        longitude: 106.8285,
        isOnline: true,
        isCurrentUser: true,
        status: StudyStatusModel(
          emoji: '🎯',
          label: 'Deep Focus',
          updatedAt: DateTime.parse('2026-10-26T00:00:00Z'),
        ),
      );

      final json = user.toJson();
      expect(json['id'], 'u-rian');
      expect(json['name'], 'Rian M.');
      expect(json['isCurrentUser'], true);
      expect(json['status']?['emoji'], '🎯');

      final fromJson = UserPresenceModel.fromJson(json);
      expect(fromJson.id, user.id);
      expect(fromJson.isCurrentUser, true);
      expect(fromJson.status?.emoji, '🎯');
      expect(fromJson.avatarInitials, 'RM');
    });
  });

  group('MapViewModel Tests', () {
    test('initUserLocation and setStudyStatus update myLocation and notify listeners', () async {
      final vm = MapViewModel();
      await Future.delayed(const Duration(milliseconds: 250));

      expect(vm.myLocation, isNotNull);
      expect(vm.myLocation?.isCurrentUser, true);

      final newStatus = StudyStatusModel(
        emoji: '🤯',
        label: 'Pusing',
        customMessage: 'Mumet tugas jaringan',
        updatedAt: DateTime.now(),
      );

      vm.setStudyStatus(newStatus);
      expect(vm.currentStatus.emoji, '🤯');
      expect(vm.myLocation?.status?.emoji, '🤯');
      expect(vm.myLocation?.status?.displayText, 'Mumet tugas jaringan');

      int triggerBefore = vm.recenterTrigger;
      vm.recenterToMyLocation();
      expect(vm.recenterTrigger, triggerBefore + 1);

      final users = vm.nearbyUsers;
      expect(users.isNotEmpty, true);

      vm.selectUser(users.first);
      expect(vm.selectedUser?.id, users.first.id);
      vm.clearSelectedUser();
      expect(vm.selectedUser, isNull);
    });
  });

  group('MapStatusBubbleWidget Tests', () {
    testWidgets('Renders emoji and label properly', (tester) async {
      final status = StudyStatusModel(
        emoji: '☕',
        label: 'Santai',
        customMessage: 'Ngopi santai',
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: MapStatusBubbleWidget(
            status: status,
            isMyLocation: true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('☕'), findsOneWidget);
      expect(find.text('Ngopi santai'), findsOneWidget);
    });
  });

  group('MapMyLocationMarkerWidget Tests', () {
    testWidgets('Renders SAYA badge, pulsing ring, and handles tap', (tester) async {
      bool tapped = false;
      final myUser = UserPresenceModel(
        id: 'me',
        name: 'Saya',
        campus: 'UI',
        major: 'CS',
        currentSpotName: 'Library',
        currentTopic: 'OS',
        latitude: -6.36,
        longitude: 106.82,
        isCurrentUser: true,
        status: StudyStatusModel(
          emoji: '🔥',
          label: 'Semangat',
          updatedAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: MapMyLocationMarkerWidget(
            user: myUser,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('SAYA'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);

      await tester.tap(find.byType(MapMyLocationMarkerWidget));
      await tester.pump();
      expect(tapped, true);
    });
  });

  group('MapStatusPickerBottomSheet Tests', () {
    testWidgets('Selects mood preset, types message, and applies status', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final vm = MapViewModel();

      await tester.pumpWidget(
        buildTestWidget(
          mapViewModel: vm,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  builder: (_) => MapStatusPickerBottomSheet(mapViewModel: vm),
                );
              },
              child: const Text('Buka Modal Status'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Modal Status'));
      await tester.pumpAndSettle();

      expect(find.text('Status Belajarmu Sekarang'), findsOneWidget);
      expect(find.text('Deep Focus'), findsOneWidget);

      // Select 'Deep Focus' preset
      await tester.tap(find.text('Deep Focus'));
      await tester.pumpAndSettle();

      // Enter custom message
      await tester.enterText(find.byType(TextField), 'Lagi nugas serius');
      await tester.pump();

      // Tap apply button
      await tester.tap(find.text('Pasang Status di Peta'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(vm.currentStatus.emoji, '🎯');
      expect(vm.currentStatus.displayText, 'Lagi nugas serius');
    });
  });

  group('MapRecenterFabWidget Tests', () {
    testWidgets('Tapping calls onPressed callback', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: MapRecenterFabWidget(onPressed: () => pressed = true),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MapRecenterFabWidget));
      await tester.pump();
      expect(pressed, true);
    });
  });

  group('MapUserMarkerWidget Tests', () {
    testWidgets('Renders pin initials, name label, and status bubble', (tester) async {
      bool tapped = false;
      final testUser = UserPresenceModel(
        id: 'u-test',
        name: 'Rian M.',
        campus: 'UI',
        major: 'Informatika',
        currentSpotName: 'Perpus',
        currentTopic: 'Flutter',
        latitude: -6.36,
        longitude: 106.82,
        isOnline: true,
        status: StudyStatusModel(
          emoji: '🔥',
          label: 'Semangat',
          updatedAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: MapUserMarkerWidget(
            user: testUser,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('RM'), findsOneWidget);
      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);

      await tester.tap(find.byType(MapUserMarkerWidget));
      await tester.pump();
      expect(tapped, true);
    });
  });

  group('MapUserDetailBottomSheet Tests', () {
    testWidgets('Renders mini profile preview with all badges and buttons', (tester) async {
      final testUser = UserPresenceModel(
        id: 'u-rian',
        name: 'Rian M.',
        campus: 'Universitas Indonesia',
        major: 'Mobile App Dev (Android)',
        currentSpotName: 'Perpustakaan Pusat',
        currentTopic: 'Python Dev',
        latitude: -6.3625,
        longitude: 106.8285,
        isOnline: true,
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  builder: (_) => MapUserDetailBottomSheet(user: testUser),
                );
              },
              child: const Text('Buka User Detail'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka User Detail'));
      await tester.pumpAndSettle();

      expect(find.text('Rian M.'), findsOneWidget);
      expect(find.text('Perpustakaan Pusat'), findsOneWidget);
      expect(find.text('Mobile App Dev (Android)'), findsOneWidget);
      expect(find.text('Python Dev'), findsOneWidget);
      expect(find.text('120m dari lokasimu'), findsOneWidget);
      expect(find.text('Buka Obrolan Langsung dengan Rian M.'), findsOneWidget);
      expect(find.text('Ajak Belajar Bareng (Knock)'), findsOneWidget);

      // Tap close button (✕)
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
    });
  });

  group('MapScreen Integration Tests', () {
    testWidgets('Displays My Location marker, user presence markers, and Recenter FAB', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final mapVm = MapViewModel();

      await tester.pumpWidget(
        buildTestWidget(
          mapViewModel: mapVm,
          child: const MapScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Check My Location marker and friends markers
      expect(find.byType(MapMyLocationMarkerWidget), findsOneWidget);
      expect(find.byType(MapUserMarkerWidget), findsWidgets);
      expect(find.byType(MapRecenterFabWidget), findsOneWidget);

      // Tap on My Location marker to open status picker sheet
      await tester.tap(find.byType(MapMyLocationMarkerWidget));
      await tester.pumpAndSettle();

      expect(find.byType(MapStatusPickerBottomSheet), findsOneWidget);
      expect(find.text('Status Belajarmu Sekarang'), findsOneWidget);

      // Close status picker
      await tester.tap(
        find.descendant(
          of: find.byType(MapStatusPickerBottomSheet),
          matching: find.byIcon(Icons.close_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MapStatusPickerBottomSheet), findsNothing);

      // Tap on Recenter FAB
      await tester.tap(find.byType(MapRecenterFabWidget));
      await tester.pumpAndSettle();
      expect(find.textContaining('Memusatkan ke lokasi Anda'), findsOneWidget);
    });
  });
}
