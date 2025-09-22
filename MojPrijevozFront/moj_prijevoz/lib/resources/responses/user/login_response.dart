import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;
  final int id;

  LoginResponse({required this.token, required this.id});

  factory LoginResponse.fromMap(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
