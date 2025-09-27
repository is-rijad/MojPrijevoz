import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';

void registerServices() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton(() => UIProvider());

  getIt.registerFactory<HttpProvider>(() => HttpProvider());
  getIt.registerFactory<UserProvider>(() => UserProvider());
  getIt.registerFactory<CityProvider>(() => CityProvider());
  getIt.registerFactory<VehicleProvider>(() => VehicleProvider());
  getIt.registerFactory<UserVehicleProvider>(() => UserVehicleProvider());
  getIt.registerFactory<AuthProvider>(() => AuthProvider());
}

void main() {
  registerServices();
  runZonedGuarded(
    () => runApp(const MPApp()),
    (ex, stack) => ErrorHandler.handle(ex, stack),
  );
}

class MPApp extends StatelessWidget {
  const MPApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppOverlay();
  }
}
