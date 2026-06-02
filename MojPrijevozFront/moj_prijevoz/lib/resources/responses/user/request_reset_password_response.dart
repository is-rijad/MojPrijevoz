import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'request_reset_password_response.g.dart';

@JsonSerializable()
class RequestResetPasswordResponse implements JsonResponse {
  String code;
  @override
  int get id => throw UnimplementedError();

  RequestResetPasswordResponse({required this.code});

  @override
  Map<String, dynamic> toJson() => _$RequestResetPasswordResponseToJson(this);

  factory RequestResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResetPasswordResponseFromJson(json);
}
