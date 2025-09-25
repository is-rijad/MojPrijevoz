import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/hive_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class AccessTokenHandler {
  static final _accessTokenKey = "access_token";

  static Future<void> setAccessToken(String token) async {
    var hive = await HiveProvider.getInstance();
    await hive.put(_accessTokenKey, token);
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
    await hive.delete(_accessTokenKey);
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

  static Future<int?> getProfileId(ProfileType profileType) async {
    var payload = await getPayload();
    return profileType == ProfileType.passenger
        ? payload.passengerProfileId
        : payload.driverProfileId;
  }
}
