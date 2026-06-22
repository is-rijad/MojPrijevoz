import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'refresh_token_request.g.dart';

@JsonSerializable()
class RefreshTokenRequest implements JsonRequest {
  String? accessToken;
  String? refreshToken;

  RefreshTokenRequest({this.accessToken, this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
