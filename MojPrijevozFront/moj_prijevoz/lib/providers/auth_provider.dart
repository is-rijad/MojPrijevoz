import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moj_prijevoz/providers/hive_provider.dart';
import 'package:moj_prijevoz/resources/helpers/auth_info.dart';

class AuthProvider {
  static final _accessTokenKey = "access_token";

  Future<void> setAccessToken(String token) async {
    var hive = await HiveProvider.getInstance();
    hive.put(_accessTokenKey, token);
  }

  Future<String> getAccessToken() async {
    var hive = await HiveProvider.getInstance();
    var token = hive.get(_accessTokenKey);
    if (token == null) {
      throw Exception("User is not logged in!");
    }
    return token;
  }

  Future<AuthInfo> getAuthInfo() async {
    var token = await getAccessToken();
    var payload = JwtDecoder.decode(token);
    return AuthInfo(
      username: payload["username"],
      userId: int.parse(payload["sub"]),
    );
  }
}
