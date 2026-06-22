import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/dio_client.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/hub_connection.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/dtos/fare_location/fare_location_dto.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moj_prijevoz/common/env.dart';
import 'package:signalr_netcore/signalr_client.dart';

class FareLocationProvider extends ChangeNotifier {
  Position? myLocation;
  FareLocationDto? location;
  MapsRouteResponse? routeData;
  Completer<void>? locationReceiver;
  @override
  void dispose() {
    locationReceiver = null;
    super.dispose();
  }

  Future<void> receiveLocation(Map<String, dynamic> data) async {
    if (locationReceiver == null || locationReceiver!.isCompleted) return;
    locationReceiver?.complete();
    final locationDto = FareLocationDto.fromJson(data);
    setNewLocation(locationDto);
    await _refreshRoute(locationDto);
  }

  void setMyLocation(Position location) {
    myLocation = location;
    notifyListeners();
  }

  void setNewLocation(FareLocationDto location) {
    this.location = location;
    notifyListeners();
  }

  Future<void> _refreshRoute(FareLocationDto location) async {
    routeData = await GetIt.I<MapProvider>().getRoute(
      NominatimCityDto(
        long: myLocation!.longitude.toString(),
        lat: myLocation!.latitude.toString(),
      ),
      NominatimCityDto(long: location.lon, lat: location.lat),
      includeLocationNames: true,
    );
    notifyListeners();
  }

  Future<void> sendLocation(String requesterId) async {
    final data = await GetIt.I<LocationProvider>().getLocationData();
    if (data != null) {
      await GetIt.I<HubConnectionProvider>().hubConnection!.invoke(
        'SendLocation',
        args: [
          FareLocationDto(
            userId: int.parse(requesterId),
            lat: data.latitude.toString(),
            lon: data.longitude.toString(),
            dateTime: DateTime.now().toUtc(),
            isAccurate: true,
          ),
        ],
      );
    }
  }

  Future getLastLocation(int userId) async {
    try {
      locationReceiver = Completer();
      notifyListeners();

      await GetIt.I<HubConnectionProvider>().hubConnection!.invoke(
        'GetLastLocation',
        args: [userId.toString()],
      );
      await Future.any([
        locationReceiver!.future,
        Future.delayed(const Duration(seconds: 20), () {
          if (locationReceiver == null || locationReceiver!.isCompleted) return;
          locationReceiver!.completeError(
            UserException("Lokacija nije dostupna"),
          );
          notifyListeners();
        }),
      ]);
    } on Exception {
      rethrow;
    }
  }

  Future requestNewLocation(int userId) async {
    try {
      locationReceiver = Completer();
      notifyListeners();

      await GetIt.I<HubConnectionProvider>().hubConnection!.invoke(
        'RequestLocation',
        args: [userId.toString()],
      );

      await Future.any([
        locationReceiver!.future,
        Future.delayed(const Duration(seconds: 20), () {
          if (locationReceiver == null || locationReceiver!.isCompleted) return;
          locationReceiver!.completeError(
            UserException("Lokacija nije dostupna"),
          );
          notifyListeners();
        }),
      ]);
    } on Exception {
      rethrow;
    }
  }

  static Future handleRequestFromBackground(Map<String, dynamic> data) async {
    final requesterId = data['RequesterId']!;
    final sharedPrefs = await SharedPreferences.getInstance();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permissions = await Geolocator.checkPermission();
    if (permissions != LocationPermission.always || !serviceEnabled) {
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    DioClient.init(null);
    await DioClient.dio.post(
      '${Environment.apiUrl}fare/location',
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${sharedPrefs.getString(Constants.accessTokenKey)}',
        },
      ),
      data: FareLocationDto(
        dateTime: DateTime.now().toUtc(),
        lat: pos.latitude.toString(),
        lon: pos.longitude.toString(),
        userId: int.parse(requesterId),
        isAccurate: true,
      ).toJson(),
    );
  }
}
