import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'request_reset_password_request.g.dart';

@JsonSerializable()
class RequestResetPasswordRequest implements JsonRequest {
  String? email;

  RequestResetPasswordRequest({this.email});

  @override
  Map<String, dynamic> toJson() => _$RequestResetPasswordRequestToJson(this);

  factory RequestResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestResetPasswordRequestFromJson(json);
}
