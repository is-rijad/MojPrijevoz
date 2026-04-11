import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moj_prijevoz/providers/hive_provider.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/resources/responses/user/access_token_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class AuthProvider with ChangeNotifier {
  late AccessTokenPayload _accessTokenPayload;
  AccessTokenPayload get accessTokenPayload => _accessTokenPayload;

  final HttpProvider _httpProvider = GetIt.I<HttpProvider>();
  static final _accessTokenKey = "access_token";
  final _providerName = "auth";

  AuthProvider(AccessTokenPayload? payload) {
    if (payload != null) {
      _accessTokenPayload = payload;
      notifyListeners();
    }
  }

  Future<AccessTokenResponse> login(LoginRequest request) async {
    final response = await _httpProvider
        .post<LoginRequest, AccessTokenResponse>(_providerName, request);
    await _setAccessToken(response.token);
    return response;
  }

  Future<AccessTokenResponse> getNewToken() async {
    final response = await _httpProvider.getSingle<AccessTokenResponse>(
      _providerName,
    );
    await _setAccessToken(response.token);
    return response;
  }

  Future<void> logout() async {
    var hive = await HiveProvider.getInstance();
    await hive.delete(_accessTokenKey);
  }

  Future<void> _setAccessToken(String token) async {
    var hive = await HiveProvider.getInstance();
    await hive.put(_accessTokenKey, token);
    _accessTokenPayload = await getPayload();
    notifyListeners();
  }

  static Future<String> getAccessToken() async {
    var hive = await HiveProvider.getInstance();
    var token = hive.get(_accessTokenKey);
    if (token == null) {
      throw Exception("User is not logged in!");
    }
    return token;
  }

  Future<int> getUserId() async {
    var token = await getAccessToken();
    var payload = JwtDecoder.decode(token);
    return int.parse(payload["sub"]);
  }

  static Future<AccessTokenPayload> getPayload() async {
    var token = await getAccessToken();
    var payload = JwtDecoder.decode(token);
    return parseJson<AccessTokenPayload>(payload);
  }

  Future<int?> getProfileId(ProfileType profileType) async {
    var payload = await getPayload();
    return profileType == ProfileType.passenger
        ? payload.passengerProfileId
        : payload.driverProfileId;
  }
}
