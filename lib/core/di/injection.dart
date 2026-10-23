import 'package:get_it/get_it.dart';
import '../../features/auth/data/source/auth_remote_source.dart';
import '../../features/auth/view/viewmodels/auth_view_models.dart';
import '../../features/friends/view/viewmodels/friends_provider.dart';
import '../../features/map/view/viewmodels/study_map_provider.dart';
import '../../features/profile/view/viewmodels/profile_provider.dart';
import '../../features/session/view/viewmodels/session_timer_provider.dart';
import '../providers/navigation_provider.dart';
import '../../router/app_router.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Data Sources / Services
  locator.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());

  // 2. ViewModels / Providers
  locator.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(locator<AuthRemoteSource>()),
  );

  locator.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  locator.registerLazySingleton<StudyMapProvider>(() => StudyMapProvider());
  locator.registerLazySingleton<SessionTimerProvider>(() => SessionTimerProvider());
  locator.registerLazySingleton<FriendsProvider>(() => FriendsProvider());
  locator.registerLazySingleton<ProfileProvider>(() => ProfileProvider());

  // 3. Router
  locator.registerLazySingleton<AppRouter>(
    () => AppRouter(authViewModel: locator<AuthViewModel>()),
  );
}
