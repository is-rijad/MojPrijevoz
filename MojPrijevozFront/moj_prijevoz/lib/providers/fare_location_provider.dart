import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/dio_client.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/providers/hub_connection.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/dtos/fare_location/fare_location_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moj_prijevoz/common/env.dart';

class FareLocationProvider extends ChangeNotifier {
  final _uiProvider = GetIt.I<UIProvider>();
  final _hubConnection = GetIt.I<HubConnectionProvider>().hubConnection;
  FareLocationDto? location;
  Completer<void>? _locationReceived;

  void receiveLocation(Map<String, dynamic> data) {
    _locationReceived?.complete();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      location = FareLocationDto.fromJson(data);
      notifyListeners();
    });
  }

  Future<void> sendLocation(String requesterId) async {
    final data = await GetIt.I<LocationProvider>().getLocationData();
    if (data != null) {
      await _hubConnection!.invoke(
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
  }

  Future getLastLocation(int userId) async {
    await _hubConnection!.invoke('GetLastLocation', args: [userId.toString()]);
  }

  Future requestNewLocation(int userId) async {
    _uiProvider.startLoading();

    try {
      _locationReceived = Completer();

      await _hubConnection!.invoke(
        'RequestLocation',
        args: [userId.toString()],
      );

      await Future.any([
        _locationReceived!.future,
        Future.delayed(const Duration(seconds: 10)),
      ]);
    } on Exception {
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
          userId: requesterId,
        ).toJson(),
      );
    }
  }
}
