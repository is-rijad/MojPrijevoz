import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
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

  getIt.registerFactoryParam<HttpProvider, LoadingType, void>(
    (p1, p2) => HttpProvider(loadingType: p1),
  );
  getIt.registerFactoryParam<UserProvider, LoadingType, void>(
    (p1, p2) => UserProvider(loadingType: p1),
  );
  getIt.registerFactoryParam<CityProvider, LoadingType, void>(
    (p1, p2) => CityProvider(loadingType: p1),
  );

  getIt.registerFactoryParam<VehicleProvider, LoadingType, void>(
    (p1, p2) => VehicleProvider(loadingType: p1),
  );
  getIt.registerFactoryParam<UserVehicleProvider, LoadingType, void>(
    (p1, p2) => UserVehicleProvider(loadingType: p1),
  );
  getIt.registerFactoryParam<AuthProvider, LoadingType, void>(
    (p1, p2) => AuthProvider(loadingType: p1),
  );
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
