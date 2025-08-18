import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:start/core/network/check_internet.dart';
import 'package:start/core/network/check_internet_web.dart';

final GetIt sl = GetIt.instance;  // Use consistent name

Future<void> setupLocator() async {
  if (kIsWeb) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoWeb());
  } else {
    sl.registerLazySingleton(() => InternetConnectionChecker());
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()),
    );
  }
}