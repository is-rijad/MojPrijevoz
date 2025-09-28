import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'create_user_request.g.dart';

@JsonSerializable()
class CreateUserRequest implements JsonRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;
  String? passwordAgain;
  int? cityId;

  CreateUserRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
    this.passwordAgain,
    this.cityId,
  });

  @override
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
}
