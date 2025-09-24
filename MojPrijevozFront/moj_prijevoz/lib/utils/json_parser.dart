import 'dart:developer';

import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/user/access_token_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  AccessTokenResponse: (json) => AccessTokenResponse.fromJson(json),
  CityResponse: (json) => CityResponse.fromJson(json),
  UserResponse: (json) => UserResponse.fromJson(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromJson(json),
  UserVehicleResponse: (json) => UserVehicleResponse.fromJson(json),
  VehicleResponse: (json) => VehicleResponse.fromJson(json),
};

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  log("PARSING TO JSON => $json");
  return fromJson(json) as T;
}

abstract class JsonParsable {
  Map<String, dynamic> toJson();
}
