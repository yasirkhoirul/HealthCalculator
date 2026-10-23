import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/router/app_router_redirect.dart';
import 'package:health_calculator/router/app_routes.dart';
import '../core/widgets/scaffold_with_nav_bar.dart';
import '../features/auth/view/pages/auth_login_page.dart';
import '../features/auth/view/pages/auth_signup_page.dart';
import '../features/friends/view/pages/friends_page.dart';
import '../features/map/view/pages/location_details_page.dart';
import '../features/map/view/pages/map_page.dart';
import '../features/profile/view/pages/profile_page.dart';
import '../features/session/view/pages/session_page.dart';
import '../features/study/view/pages/create_room_page.dart';
import '../features/study/view/pages/create_schedule_page.dart';
import '../stateWithMe.dart';

/// Konfigurasi routing terpusat aplikasi StudyMap menggunakan GoRouter & StatefulShellRoute
class AppRouter {
  // Navigator Keys
  final AuthViewModel authViewModel;
  AppRouter({required this.authViewModel});
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  

  late final GoRouter router = GoRouter(
    redirect: AppRouterRedirect.redirect,
    refreshListenable: authViewModel,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.loginPath,
    routes: [
      // 1. Root redirect to Login
      GoRoute(
        path: AppRoutes.rootPath,
        redirect: (_, __) => AppRoutes.loginPath,
      ),

      // 2. Authentication Routes
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AuthLoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signupPath,
        name: AppRoutes.signup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AuthSignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.stateWithMePath,
        name: AppRoutes.stateWithMe,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const StateWithMe(),
      ),

      // 3. Stateful Shell Route dengan Bottom Navigation Bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Tab Map / Beranda
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mapPath,
                name: AppRoutes.map,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),

          // Branch 1: Tab Temukan Teman / Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.friendsPath,
                name: AppRoutes.friends,
                builder: (context, state) => const FriendsPage(),
              ),
            ],
          ),

          // Branch 2: Tab Active Session
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sessionPath,
                name: AppRoutes.session,
                builder: (context, state) => const SessionPage(),
              ),
            ],
          ),

          // Branch 3: Tab Pengaturan / Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // 4. Sub-routes (Menimpa layar penuh / Tanpa Bottom Navigation Bar)
      GoRoute(
        path: AppRoutes.locationDetailsPath,
        name: AppRoutes.locationDetails,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'spot-1';
          return LocationDetailsPage(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.createSchedulePath,
        name: AppRoutes.createSchedule,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateSchedulePage(),
      ),
      GoRoute(
        path: AppRoutes.createRoomPath,
        name: AppRoutes.createRoom,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateRoomPage(),
      ),
    ],
  );
}