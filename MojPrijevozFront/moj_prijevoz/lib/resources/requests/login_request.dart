import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/json_parser.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest implements JsonParsable {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
