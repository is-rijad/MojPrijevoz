import 'dart:developer';

import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/user/login_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  LoginResponse: (json) => LoginResponse.fromMap(json),
  CityResponse: (json) => CityResponse.fromMap(json),
  UserResponse: (json) => UserResponse.fromMap(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromMap(json),
};

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  log("PARSING TO JSON => $json");
  return fromJson(json) as T;
}

abstract class JsonParsable {
  Map<String, dynamic> toMap();
}
