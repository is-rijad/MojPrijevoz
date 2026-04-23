import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:moj_prijevoz/common/env.dart';

class FareLocationProvider extends ChangeNotifier {
  late HubConnection _hubConnection;
  NominatimCityDto? location;
  bool get isReady => _hubConnection.state == HubConnectionState.Connected;

  FareLocationProvider() {
    print("CREATING");

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "${Environment.apiUrl.split("api")[0]}hubs/fareLocations",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await AuthProvider.getAccessToken(),
          ),
        )
        .build();

    _hubConnection.on('ReceiveLocation', (args) {
      final data = args![0] as Map<String, dynamic>;

      final lat = data['lat'];
      final lng = data['long'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        location = NominatimCityDto(long: lng, lat: lat);
        notifyListeners();
      });
    });

    _hubConnection.on('SendYourLocation', (_) async {
      final data = await GetIt.I<LocationProvider>().getLocationData();

      if (data != null) {
        await _hubConnection.invoke(
          'UpdateLocation',
          args: [data.latitude.toString(), data.longitude.toString()],
        );
      }
    });
    _hubConnection.on('error', (args) => print('Hub error: $args'));

    _hubConnection.start();
  }

  @override
  void dispose() {
    print('>>> FareLocationProvider DISPOSED');
    _hubConnection.stop();
    super.dispose();
  }

  Future _checkConnection() async {
    while (!isReady) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future getLastLocation(int userId) async {
    await _checkConnection();
    await _hubConnection.invoke('GetCachedLocation', args: [userId.toString()]);
  }

  Future requestNewLocation(int userId) async {
    await _checkConnection();
    await _hubConnection.invoke('RequestLocation', args: [userId.toString()]);
  }
}
