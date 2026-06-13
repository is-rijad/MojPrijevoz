import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/dtos/fare_location/fare_location_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:moj_prijevoz/common/env.dart';

class FareLocationProvider extends ChangeNotifier {
  late final HubConnection _hubFareLocationsConnection;
  final _uiProvider = GetIt.I<UIProvider>();
  FareLocationDto? location;
  Completer<void>? _locationReceived;
  bool get isReady =>
      _hubFareLocationsConnection.state == HubConnectionState.Connected;

  FareLocationProvider() {
    _buildConnection();

    _hubFareLocationsConnection.on('ReceiveLocation', (args) {
      final data = args![0] as Map<String, dynamic>;
      _locationReceived?.complete();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        location = FareLocationDto.fromJson(data);
        notifyListeners();
      });
    });
  }

  void _buildConnection() {
    _hubFareLocationsConnection = HubConnectionBuilder()
        .withUrl(
          "${Environment.hubBaseUrl}farelocations",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await AuthProvider.getAccessToken(),
          ),
        )
        .build();
    _hubFareLocationsConnection.on("LocationRequested", (args) async {
      final requesterId = args![0] as String;
      final data = await GetIt.I<LocationProvider>().getLocationData();
      if (data != null) {
        await _checkConnection();
        await _hubFareLocationsConnection.invoke(
          'SendLocation',
          args: [
            FareLocationDto(
              userId: int.parse(requesterId),
              lat: data.latitude.toString(),
              lon: data.longitude.toString(),
              dateTime: DateTime.now().toUtc(),
            ),
          ],
        );
      } else {
        throw UserException("Nije moguće pronaći lokaciju!");
      }
    });
    _hubFareLocationsConnection.on(
      'error',
      (args) => print('Hub $_hubFareLocationsConnection error: $args'),
    );
    _hubFareLocationsConnection.start();
  }

  @override
  void dispose() {
    _hubFareLocationsConnection.stop();
    super.dispose();
  }

  Future _checkConnection() async {
    if (_hubFareLocationsConnection.state == HubConnectionState.Disconnected) {
      await _hubFareLocationsConnection.start();
    }
    while (!isReady) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future getLastLocation(int userId) async {
    await _checkConnection();
    await _hubFareLocationsConnection.invoke(
      'GetLastLocation',
      args: [userId.toString()],
    );
  }

  Future requestNewLocation(int userId) async {
    _uiProvider.startLoading();

    try {
      _locationReceived = Completer();
      await _checkConnection();

      await _hubFareLocationsConnection.invoke(
        'RequestLocation',
        args: [userId.toString()],
      );

      await Future.any([
        _locationReceived!.future,
        Future.delayed(const Duration(seconds: 10)),
      ]);
    } on Exception catch (e) {
      rethrow;
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future handleRequestFromBackground(Map<String, dynamic> data) async {
    final requesterId = data['requesterId']!;
    final sharedPrefs = await SharedPreferences.getInstance();

    final permissions = await Geolocator.checkPermission();
    if (permissions == LocationPermission.always) {
      final pos = await Geolocator.getCurrentPosition();
      final dio = Dio();
      await dio.post(
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
          userId: requesterId,
        ).toJson(),
      );
    }
  }
}
