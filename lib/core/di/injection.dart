import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  // TODO: Daftarkan Data Sources, Services, dan ViewModels di sini
  // Contoh:
  // locator.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());
  // locator.registerFactory<AuthViewModel>(() => AuthViewModel(locator<AuthRemoteSource>()));
}
