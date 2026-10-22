import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  // Route Names
  static const String root = 'root';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String stateWithMe = 'state-with-me';

  // Main Shell Tab Route Names
  static const String map = 'map';
  static const String friends = 'friends';
  static const String session = 'session';
  static const String profile = 'profile';

  // Sub-route Names
  static const String locationDetails = 'locationDetails';
  static const String createSchedule = 'createSchedule';
  static const String createRoom = 'createRoom';

  // Route Paths
  static const String rootPath = '/';
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String stateWithMePath = '/state-with-me';

  static const String mapPath = '/map';
  static const String friendsPath = '/friends';
  static const String sessionPath = '/session';
  static const String profilePath = '/profile';

  static const String locationDetailsPath = '/location-details/:id';
  static const String createSchedulePath = '/create-schedule';
  static const String createRoomPath = '/create-room';

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: loginPath,
    routes: [
      // 1. Root redirect to Login
      GoRoute(
        path: rootPath,
        redirect: (_, __) => loginPath,
      ),

      // 2. Authentication Routes
      GoRoute(
        path: loginPath,
        name: login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AuthLoginPage(),
      ),
      GoRoute(
        path: signupPath,
        name: signup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AuthSignUpPage(),
      ),
      GoRoute(
        path: stateWithMePath,
        name: stateWithMe,
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
                path: mapPath,
                name: map,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),

          // Branch 1: Tab Temukan Teman / Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: friendsPath,
                name: friends,
                builder: (context, state) => const FriendsPage(),
              ),
            ],
          ),

          // Branch 2: Tab Active Session
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: sessionPath,
                name: session,
                builder: (context, state) => const SessionPage(),
              ),
            ],
          ),

          // Branch 3: Tab Pengaturan / Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                name: profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // 4. Sub-routes (Menimpa layar penuh / Tanpa Bottom Navigation Bar)
      GoRoute(
        path: locationDetailsPath,
        name: locationDetails,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'spot-1';
          return LocationDetailsPage(id: id);
        },
      ),
      GoRoute(
        path: createSchedulePath,
        name: createSchedule,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateSchedulePage(),
      ),
      GoRoute(
        path: createRoomPath,
        name: createRoom,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateRoomPage(),
      ),
    ],
  );
}