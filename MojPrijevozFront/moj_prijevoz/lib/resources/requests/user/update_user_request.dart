import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/gender.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest extends JsonRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? oldPassword;
  String? password;
  String? passwordAgain;
  Gender? gender;
  int? cityId;

  UpdateUserRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.oldPassword,
    this.password,
    this.passwordAgain,
    this.gender,
    this.cityId,
  });

  @override
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  factory UpdateUserRequest.fromJson(json) => _$UpdateUserRequestFromJson(json);
}
