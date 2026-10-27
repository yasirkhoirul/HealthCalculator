import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/chat/data/models/chat_message_model.dart';
import 'package:health_calculator/features/chat/data/models/knock_payload_model.dart';
import 'package:health_calculator/features/chat/view/pages/chat_detail_page.dart';
import 'package:health_calculator/features/chat/view/widgets/chat_app_bar_header_widget.dart';
import 'package:health_calculator/features/chat/view/widgets/chat_bubble_widget.dart';
import 'package:health_calculator/features/chat/view/widgets/chat_follow_banner_widget.dart';
import 'package:health_calculator/features/chat/view/widgets/chat_input_bar_widget.dart';
import 'package:health_calculator/features/chat/view/widgets/chat_knock_card_widget.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
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
    required String userId,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
        ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
        ChangeNotifierProvider.value(value: locator<FriendsProvider>()),
        ChangeNotifierProvider.value(value: locator<StudyMapProvider>()),
        ChangeNotifierProvider.value(value: locator<SessionTimerProvider>()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: ChatDetailPage(userId: userId),
      ),
    );
  }

  group('ChatDetailPage Widget Tests (TikTok DM UX/UI)', () {
    testWidgets('Renders TikTok DM AppBar with user status and message stream', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1'));
      await tester.pumpAndSettle();

      expect(find.byType(ChatDetailPage), findsOneWidget);
      expect(find.byType(ChatAppBarHeaderWidget), findsOneWidget);
      expect(find.text('Alif Fathur R.'), findsOneWidget);
      expect(find.byType(ChatInputBarWidget), findsOneWidget);
      expect(find.byType(ChatBubbleWidget), findsWidgets);
      expect(find.byType(ChatKnockCardWidget), findsOneWidget);
    });

    testWidgets('Displays TikTok DM follow banner for non-friends and adds friend', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-5'));
      await tester.pumpAndSettle();

      expect(find.byType(ChatFollowBannerWidget), findsOneWidget);
      expect(find.text('Tambah Teman di StudyMap'), findsOneWidget);

      // Tap on "+ Tambah" button in banner
      await tester.tap(find.text('Tambah'));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();

      // Banner disappears after adding friend
      expect(find.byType(ChatFollowBannerWidget), findsNothing);
    });

    testWidgets('Sends message via input bar and displays new bubble', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1'));
      await tester.pumpAndSettle();

      final inputFinder = find.byType(TextField);
      expect(inputFinder, findsOneWidget);

      // Type message
      await tester.enterText(inputFinder, 'Halo, aku sudah di lantai 2!');
      await tester.pump();

      // Tap send button (arrow up icon)
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Halo, aku sudah di lantai 2!'), findsOneWidget);
    });

    testWidgets('Knock button opens bottom sheet and sends Knock card to chat', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1'));
      await tester.pumpAndSettle();

      // Tap bolt/knock icon in input bar
      await tester.tap(find.byIcon(Icons.bolt_rounded).last);
      await tester.pumpAndSettle();

      // Bottom sheet content
      expect(find.text('Kirim Ajakan Knock'), findsOneWidget);
      expect(find.text('Kirim Kartu Knock ke Chat'), findsOneWidget);

      // Submit knock invite
      await tester.tap(find.text('Kirim Kartu Knock ke Chat'));
      await tester.pumpAndSettle();

      expect(find.byType(ChatKnockCardWidget), findsWidgets);
    });

    testWidgets('Interactive knock card can be accepted in chat', (tester) async {
      // buddy-5 has a pending knock card sent to user-farhan
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-5'));
      await tester.pumpAndSettle();

      expect(find.text('Terima Ajakan'), findsOneWidget);

      await tester.tap(find.text('Terima Ajakan'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Ajakan Diterima ✓ Sesi Siap Dimulai'), findsOneWidget);
    });

    testWidgets('Renders cleanly in Dark Mode', (tester) async {
      await tester.pumpWidget(buildTestWidget(userId: 'buddy-1', themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      expect(find.byType(ChatDetailPage), findsOneWidget);
      expect(find.text('Alif Fathur R.'), findsOneWidget);
    });
  });

  group('ChatMessageModel & KnockPayloadModel JSON Serialization', () {
    test('toJson and fromJson work symmetrically', () {
      final now = DateTime(2026, 10, 25, 14, 30);
      const knock = KnockPayloadModel(
        knockId: 'k-1',
        spotName: 'Library',
        durationMinutes: 60,
        status: 'accepted',
      );

      final model = ChatMessageModel(
        id: 'test-1',
        senderId: 'user-1',
        receiverId: 'user-2',
        message: 'Tes serialisasi',
        timestamp: now,
        isRead: true,
        knockPayload: knock,
      );

      final json = model.toJson();
      expect(json['id'], 'test-1');
      expect(json['message'], 'Tes serialisasi');
      expect(json['knockPayload']['knockId'], 'k-1');

      final parsed = ChatMessageModel.fromJson(json);
      expect(parsed.id, model.id);
      expect(parsed.knockPayload?.knockId, knock.knockId);
      expect(parsed.knockPayload?.durationMinutes, 60);
      expect(parsed.knockPayload?.status, 'accepted');
    });
  });
}
