import 'package:get_it/get_it.dart';
import '../../features/auth/data/source/auth_remote_source.dart';
import '../../features/auth/view/viewmodels/auth_view_models.dart';
import '../../features/chat/data/source/chat_remote_source.dart';
import '../../features/chat/view/viewmodels/chat_viewmodel.dart';
import '../../features/friends/view/viewmodels/friends_provider.dart';
import '../../features/map/data/source/map_remote_source.dart';
import '../../features/map/data/source/search_local_source.dart';
import '../../features/map/view/viewmodels/map_search_viewmodel.dart';
import '../../features/map/view/viewmodels/map_viewmodel.dart';
import '../../features/map/view/viewmodels/study_map_provider.dart';
import '../../features/profile/data/source/profile_remote_source.dart';
import '../../features/profile/view/viewmodels/profile_viewmodel.dart';
import '../../features/profile/view/viewmodels/user_detail_viewmodel.dart';
import '../../features/session/data/source/session_remote_source.dart';
import '../../features/session/view/viewmodels/session_timer_viewmodel.dart';
import '../theme/theme_viewmodel.dart';
import '../providers/navigation_provider.dart';
import '../../router/app_router.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Data Sources / Services (LazySingleton)
  locator.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());
  locator.registerLazySingleton<ChatRemoteSource>(() => ChatRemoteSource());
  locator.registerLazySingleton<MapRemoteSource>(() => MapRemoteSource());
  locator.registerLazySingleton<SearchLocalSource>(() => SearchLocalSource());
  locator.registerLazySingleton<ProfileRemoteSource>(() => ProfileRemoteSource());
  locator.registerLazySingleton<SessionRemoteSource>(() => SessionRemoteSource());

  // 2. Global ViewModels (LazySingleton)
  locator.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(locator<AuthRemoteSource>()),
  );
  locator.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel());
  locator.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(remoteSource: locator<ProfileRemoteSource>()),
  );
  locator.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  locator.registerLazySingleton<StudyMapProvider>(() => StudyMapProvider());
  locator.registerLazySingleton<MapViewModel>(
    () => MapViewModel(remoteSource: locator<MapRemoteSource>()),
  );
  locator.registerLazySingleton<SessionTimerViewModel>(
    () => SessionTimerViewModel(remoteSource: locator<SessionRemoteSource>()),
  );
  locator.registerLazySingleton<FriendsProvider>(() => FriendsProvider());

  // 3. Screen-based ViewModels (Factory)
  locator.registerFactory<ChatViewModel>(
    () => ChatViewModel(remoteSource: locator<ChatRemoteSource>()),
  );
  locator.registerFactory<UserDetailViewModel>(
    () => UserDetailViewModel(remoteSource: locator<ChatRemoteSource>()),
  );
  locator.registerFactory<MapSearchViewModel>(
    () => MapSearchViewModel(localSource: locator<SearchLocalSource>()),
  );

  // 4. Router
  locator.registerLazySingleton<AppRouter>(
    () => AppRouter(authViewModel: locator<AuthViewModel>()),
  );
}
