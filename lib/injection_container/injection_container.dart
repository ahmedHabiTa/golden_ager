import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_container.dart';

final sl = GetIt.instance;
late final SharedPreferences sharedPreferences;
Future<void> init() async {
  //! External
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);
  final firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firebaseFirestore);
  final firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firebaseStorage);

  sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  await initAuthInjection(sl);

  //! Core
  // sl.registerLazySingleton(() => InputConverter());
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
