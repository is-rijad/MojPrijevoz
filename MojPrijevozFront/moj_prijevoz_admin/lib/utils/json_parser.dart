import 'dart:developer';

import 'package:moj_prijevoz_admin/common/resources/access_token_payload.dart';
import 'package:moj_prijevoz_admin/common/resources/responses/user/access_token_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/users/user_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/users/users_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  AccessTokenResponse: (json) => AccessTokenResponse.fromJson(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromJson(json),
  UserResponse: (json) => UserResponse.fromJson(json),
  UsersResponse: (json) => UsersResponse.fromJson(json),
};

final Map<Type, Map<String, String>> _fieldsMapFactories =
    <Type, Map<String, String>>{UserResponse: UserResponse.userFieldsMap};

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  log("PARSING TO JSON => $json");
  return fromJson(json) as T;
}

Map<String, String> fieldsMap<T>() {
  final fieldMap = _fieldsMapFactories[T];
  if (fieldMap == null) throw Exception("No fields map factory for type $T");
  return fieldMap;
}

abstract class JsonParsable {
  Map<String, dynamic> toJson();
}

abstract class JsonRequest extends JsonParsable {}

abstract class JsonResponse extends JsonParsable {
  abstract final int id;
}
