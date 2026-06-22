import 'dart:developer';

import 'package:moj_prijevoz_admin/common/resources/access_token_payload.dart';
import 'package:moj_prijevoz_admin/common/resources/responses/user/access_token_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  AccessTokenResponse: (json) => AccessTokenResponse.fromJson(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromJson(json),
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

abstract class JsonRequest extends JsonParsable {}

abstract class JsonResponse extends JsonParsable {
  abstract final int id;
}
