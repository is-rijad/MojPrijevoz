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
  static final _uiProvider = GetIt.I<UIProvider>();
  static final _loadingType = LoadingType.global;

  static Future<void> setAccessToken(String token) async {
    try {
      _uiProvider.startLoading(_loadingType);
      var hive = await HiveProvider.getInstance();
      await hive.put(_accessTokenKey, token);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future<String> getAccessToken() async {
    try {
      _uiProvider.startLoading(_loadingType);
      var hive = await HiveProvider.getInstance();
      var token = hive.get(_accessTokenKey);
      if (token == null) {
        throw Exception("User is not logged in!");
      }
      return token;
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future<void> logout() async {
    try {
      _uiProvider.startLoading(_loadingType);
      var hive = await HiveProvider.getInstance();
      await hive.delete(_accessTokenKey);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future<int> getUserId() async {
    try {
      _uiProvider.startLoading(_loadingType);
      var token = await getAccessToken();
      var payload = JwtDecoder.decode(token);
      return int.parse(payload["sub"]);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future<AccessTokenPayload> getPayload() async {
    try {
      _uiProvider.startLoading(_loadingType);
      var token = await getAccessToken();
      var payload = JwtDecoder.decode(token);
      return parseJson<AccessTokenPayload>(payload);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  static Future<int?> getProfileId(ProfileType profileType) async {
    try {
      _uiProvider.startLoading(_loadingType);
      var payload = await getPayload();
      return profileType == ProfileType.passenger
          ? payload.passengerProfileId
          : payload.driverProfileId;
    } finally {
      _uiProvider.stopLoading();
    }
  }
}
