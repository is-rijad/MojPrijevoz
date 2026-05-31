import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/pages/home_page.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/providers/fare_location_provider.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/providers/search_fare_provider.dart';
import 'package:moj_prijevoz/providers/stripe_provider.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void registerServices() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton(() => UIProvider());

  getIt.registerFactory<HttpProvider>(() => HttpProvider());
  getIt.registerFactory<MapProvider>(() => MapProvider());
  getIt.registerFactory<LocationProvider>(() => LocationProvider());
  getIt.registerFactory<StripeProvider>(() => StripeProvider());
}

List<SingleChildWidget> registerProviders(AccessTokenPayload? payload) {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider(payload)),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CityProvider()),
    ChangeNotifierProvider(create: (_) => VehicleProvider()),
    ChangeNotifierProvider(create: (_) => UserVehicleProvider()),
    ChangeNotifierProvider(create: (_) => DriversDiscountProvider()),
    ChangeNotifierProvider(create: (_) => NominatimProvider()),
    ChangeNotifierProvider(create: (_) => SearchFareProvider()),
    ChangeNotifierProvider(create: (_) => FareProvider()),
    ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ChangeNotifierProvider(
      create: (context) =>
          FareOfferProvider(fareProvider: context.read<FareProvider>()),
    ),
    ChangeNotifierProvider(create: (_) => FareLocationProvider(), lazy: false),
  ];
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    registerServices();

    AccessTokenPayload? payload;
    try {
      payload = await AuthProvider.getPayload();
    } on Exception {}
    final child = payload != null ? HomePage() : LoginPage();

    Stripe.publishableKey = Environment.stripeKey;

    runApp(
      MultiProvider(
        providers: registerProviders(payload),
        child: MPApp(child: child),
      ),
    );
  }, (ex, stack) => ErrorHandler.handle(ex, stack, showSnackBar: true));
}

class MPApp extends StatelessWidget {
  final Widget child;
  const MPApp({super.key, required this.child});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppOverlay(child: child);
  }
}
