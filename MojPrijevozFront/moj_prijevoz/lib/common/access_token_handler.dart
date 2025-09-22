import 'package:moj_prijevoz/providers/hive_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class AccessTokenHandler {
  static final _accessTokenKey = "access_token";

  static Future<void> setAccessToken(String token) async {
    var hive = await HiveProvider.getInstance();
    hive.put(_accessTokenKey, token);
  }

  static Future<String> getAccessToken() async {
    // TODO: Temp
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMyIsIm5hbWUiOiJSaWphZCIsImZhbWlseV9uYW1lIjoiSXNpcmxpamEiLCJqdGkiOiI0ODIxNDEwNy1jNGYyLTQxODUtOGI4ZS04MDQwNThmNDkwYjkiLCJleHAiOjIxOTA1MzI4OTEsImlzcyI6Ik1valByaWpldm96LldlYkFwaSJ9.O6D6gd8dLm__az_9ob34OSGVAXB5OyyJmMB__2xbmgs";
    var hive = await HiveProvider.getInstance();
    var token = hive.get(_accessTokenKey);
    if (token == null) {
      throw Exception("User is not logged in!");
    }
    return token;
  }

  static Future<void> logout() async {
    var hive = await HiveProvider.getInstance();
    hive.delete(_accessTokenKey);
  }

  static Future<int> getUserId() async {
    var token = await getAccessToken();
    var payload = JwtDecoder.decode(token);
    return int.parse(payload["sub"]);
  }

  static Future<AccessTokenPayload> getPayload() async {
    var token = await getAccessToken();
    var payload = JwtDecoder.decode(token);
    return parseJson<AccessTokenPayload>(payload);
  }
}
