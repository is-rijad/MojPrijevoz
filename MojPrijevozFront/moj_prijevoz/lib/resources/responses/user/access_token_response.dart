import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'access_token_response.g.dart';

@JsonSerializable()
class AccessTokenResponse extends JsonParsable {
  final String token;
  final String refreshToken;

  AccessTokenResponse({required this.token, required this.refreshToken});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}
