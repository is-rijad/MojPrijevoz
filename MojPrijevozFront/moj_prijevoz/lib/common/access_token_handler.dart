import 'package:moj_prijevoz/providers/hive_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AccessTokenHandler {
  static final _accessTokenKey = "access_token";

  static Future<void> setAccessToken(String token) async {
    var hive = await HiveProvider.getInstance();
    hive.put(_accessTokenKey, token);
  }

  static Future<String> getAccessToken() async {
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
}
