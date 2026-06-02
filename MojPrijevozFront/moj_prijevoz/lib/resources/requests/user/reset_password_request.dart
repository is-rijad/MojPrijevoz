import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/requests/user/request_reset_password_request.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest extends RequestResetPasswordRequest {
  String? code;
  String? password;
  String? passwordAgain;

  ResetPasswordRequest({
    super.email,
    this.code,
    this.password,
    this.passwordAgain,
  });

  @override
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}
