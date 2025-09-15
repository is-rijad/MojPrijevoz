import 'package:moj_prijevoz/resources/responses/login/login_response.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, FromJson> _jsonFactories = {
  LoginResponse: (json) => LoginResponse.fromJson(json),
};

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  return fromJson(json) as T;
}

abstract class JsonParsable {
  Map<String, dynamic> toJson();
}
