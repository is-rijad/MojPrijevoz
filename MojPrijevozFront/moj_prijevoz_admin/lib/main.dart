import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/providers/user_provider.dart';
import 'package:moj_prijevoz_admin/providers/administrator_provider.dart';
import 'package:moj_prijevoz_admin/providers/city_provider.dart';
import 'package:moj_prijevoz_admin/providers/map_provider.dart';
import 'package:moj_prijevoz_admin/providers/rating_provider.dart';
import 'package:moj_prijevoz_admin/providers/transaction_provider.dart';
import 'package:moj_prijevoz_admin/providers/user_vehicles_provider.dart';
import 'package:moj_prijevoz_admin/providers/users_provider.dart';
import 'package:moj_prijevoz_admin/providers/vehicles_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:moj_prijevoz_admin/common/dio_client.dart';
import 'package:moj_prijevoz_admin/common/error_handler.dart';
import 'package:moj_prijevoz_admin/common/providers/auth_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/http_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/shared_prefs_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/access_token_payload.dart';
import 'package:moj_prijevoz_admin/common/wrappers/app_overlay.dart';

void registerServices() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton(() => UIProvider());
  getIt.registerLazySingleton<MapProvider>(() => MapProvider());

  getIt.registerFactory<HttpProvider>(() => HttpProvider());

  getIt.registerSingleton(SharedPrefsProvider());
}

List<SingleChildWidget> registerProviders(AccessTokenPayload? payload) {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider(payload)),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => UsersProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesProvider()),
    ChangeNotifierProvider(create: (_) => UserVehiclesProvider()),
    ChangeNotifierProvider(create: (_) => RatingProvider()),
    ChangeNotifierProvider(create: (_) => CityProvider()),
    ChangeNotifierProvider(create: (_) => AdministratorProvider()),
    ChangeNotifierProvider(create: (_) => TransactionProvider()),
  ];
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    registerServices();

    AccessTokenPayload? payload;
    try {
      payload = await AuthProvider.getPayload();
    } catch (_) {}
    final authProvider = AuthProvider(payload);
    DioClient.init(authProvider);

    runApp(
      MultiProvider(providers: registerProviders(payload), child: MPApp()),
    );
  }, (ex, stack) => ErrorHandler.handle(ex, stack, showSnackBar: true));
}

class MPApp extends StatelessWidget {
  const MPApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppOverlay();
  }
}
