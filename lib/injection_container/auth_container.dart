import 'package:get_it/get_it.dart';


Future<void> initAuthInjection(GetIt sl) async {
  //* provider
  // sl.registerFactory(
  //   () => AuthProvider(
  //     login: sl(),
  //   ),
  // );
  //
  // //* Use cases
  // sl.registerLazySingleton(() => Login(repository: sl()));
  //
  //
  // //* Repository
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remote: sl(), local: sl()),
  // );
  //
  // //* Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(
  //     helper: sl(),
  //     firebaseMessaging: sl(),
  //   ),
  // );
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(
  //     sharedPreference: sl(),
  //   ),
  // );
}
