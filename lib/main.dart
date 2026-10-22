import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constant/app_colors.dart';
import 'core/di/injection.dart';
import 'core/providers/navigation_provider.dart';
import 'features/auth/view/viewmodels/auth_view_models.dart';
import 'features/friends/view/viewmodels/friends_provider.dart';
import 'features/map/view/viewmodels/study_map_provider.dart';
import 'features/profile/view/viewmodels/profile_provider.dart';
import 'features/session/view/viewmodels/session_timer_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<NavigationProvider>()),
        ChangeNotifierProvider(create: (_) => locator<StudyMapProvider>()),
        ChangeNotifierProvider(create: (_) => locator<SessionTimerProvider>()),
        ChangeNotifierProvider(create: (_) => locator<FriendsProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ProfileProvider>()),
      ],
      child: MaterialApp.router(
        title: 'StudyMap',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
