import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest implements JsonParsable {
  String username;
  String password;

  LoginRequest({this.username = "", this.password = ""});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
