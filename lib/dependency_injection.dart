import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:law_enforcement/data/constants/globals.dart';
import 'package:law_enforcement/logic/local_data_source.dart';
import 'package:law_enforcement/logic/services/auth_service.dart';
import 'package:law_enforcement/logic/services/secure_storage_service.dart';
import 'package:law_enforcement/logic/services/user_services.dart';

import 'data/router/app_state.dart';

Future<void> init() async {
  sl.registerLazySingleton(() => AppState());
  sl.registerLazySingleton(() => UserService());
  sl.registerLazySingleton(() => AuthServices());
  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImg());

  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}
