import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/core/providers/navigation_provider.dart';
import 'package:health_calculator/core/theme/app_theme.dart';
import 'package:health_calculator/features/auth/data/models/auth_user_model.dart';
import 'package:health_calculator/features/auth/data/source/auth_remote_source.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/friends/view/pages/friends_page.dart';
import 'package:health_calculator/features/friends/view/viewmodels/friends_provider.dart';
import 'package:health_calculator/features/map/view/pages/map_screen.dart';
import 'package:health_calculator/features/map/view/viewmodels/map_viewmodel.dart';
import 'package:health_calculator/features/map/view/viewmodels/study_map_provider.dart';
import 'package:health_calculator/navigation/view/widgets/custom_bottom_navbar.dart';
import 'package:health_calculator/features/profile/view/pages/profile_page.dart';
import 'package:health_calculator/features/profile/view/viewmodels/profile_viewmodel.dart';
import 'package:health_calculator/features/session/view/pages/session_page.dart';
import 'package:health_calculator/features/session/view/viewmodels/session_timer_provider.dart';
import 'package:health_calculator/features/settings/view/viewmodels/theme_viewmodel.dart';
import 'package:health_calculator/router/app_router.dart';
import 'package:health_calculator/router/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImmediateAuthRemoteSource extends AuthRemoteSource {
  @override
  Future<AuthUserModel> signInWithEmail(String email) async {
    return const AuthUserModel(
      id: 'test-user',
      name: 'Test',
      email: 'test@student.ac.id',
      campus: 'UAD',
      isEmailVerified: true,
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (locator.isRegistered<AuthViewModel>()) {
      locator.reset();
    }
    setupLocator();
    locator.unregister<AuthRemoteSource>();
    locator.registerLazySingleton<AuthRemoteSource>(() => ImmediateAuthRemoteSource());
    locator.unregister<AuthViewModel>();
    locator.registerLazySingleton<AuthViewModel>(() => AuthViewModel(locator<AuthRemoteSource>()));
    locator.unregister<AppRouter>();
    locator.registerLazySingleton<AppRouter>(() => AppRouter(authViewModel: locator<AuthViewModel>()));
  });

  testWidgets('Navbar routing: tapping Timer (index 1) opens SessionPage, tapping Friends (index 2) opens FriendsPage', (tester) async {
    final authVm = locator<AuthViewModel>();
    await authVm.signInWithEmail('test@student.ac.id');

    final router = locator<AppRouter>().router;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<AuthViewModel>()),
          ChangeNotifierProvider.value(value: locator<NavigationProvider>()),
          ChangeNotifierProvider.value(value: locator<StudyMapProvider>()),
          ChangeNotifierProvider.value(value: locator<MapViewModel>()),
          ChangeNotifierProvider.value(value: locator<SessionTimerProvider>()),
          ChangeNotifierProvider.value(value: locator<FriendsProvider>()),
          ChangeNotifierProvider.value(value: locator<ProfileViewModel>()),
          ChangeNotifierProvider.value(value: locator<ThemeViewModel>()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.lightTheme,
        ),
      ),
    );

    // Navigate to map initially
    router.go(AppRoutes.mapPath);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MapScreen), findsOneWidget);
    expect(find.byType(CustomBottomNavbar), findsOneWidget);

    // Tap index 1: Timer (Active Session)
    await tester.tap(find.byIcon(Icons.timer_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify SessionPage is displayed
    expect(find.byType(SessionPage), findsOneWidget);
    expect(find.byType(FriendsPage), findsNothing);

    // Tap index 2: Chat/Friends (Rekan Belajar)
    await tester.tap(find.byIcon(Icons.chat_bubble_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify FriendsPage is displayed
    expect(find.byType(FriendsPage), findsOneWidget);
    expect(find.byType(SessionPage), findsNothing);

    // Tap index 3: Profile
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify ProfilePage is displayed
    expect(find.byType(ProfilePage), findsOneWidget);

    // Tap index 0: Map
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify MapScreen is displayed
    expect(find.byType(MapScreen), findsOneWidget);
  });
}
