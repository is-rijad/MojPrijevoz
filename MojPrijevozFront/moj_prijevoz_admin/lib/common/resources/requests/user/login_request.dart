import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest implements JsonRequest {
  String? usernameOrEmail;
  String? password;

  LoginRequest({this.usernameOrEmail, this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
