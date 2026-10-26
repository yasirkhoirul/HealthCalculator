import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/providers/navigation_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/viewmodels/auth_view_models.dart';
import 'features/friends/view/viewmodels/friends_provider.dart';
import 'features/map/view/viewmodels/map_viewmodel.dart';
import 'features/map/view/viewmodels/study_map_provider.dart';
import 'features/profile/view/viewmodels/profile_viewmodel.dart';
import 'features/session/view/viewmodels/session_timer_provider.dart';
import 'features/settings/view/viewmodels/theme_viewmodel.dart';
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
        ChangeNotifierProvider(create: (_) => locator<MapViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<SessionTimerProvider>()),
        ChangeNotifierProvider(create: (_) => locator<FriendsProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ProfileViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<ThemeViewModel>()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp.router(
            title: 'StudyMap',
            debugShowCheckedModeBanner: false,
            routerConfig: locator<AppRouter>().router,
            themeMode: themeVm.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
