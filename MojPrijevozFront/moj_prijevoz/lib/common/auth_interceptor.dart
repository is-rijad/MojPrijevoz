import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/dio_client.dart';
import 'package:moj_prijevoz/common/providers/shared_prefs_provider.dart';
import 'package:moj_prijevoz/common/resources/requests/user/refresh_token_request.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/common/providers/auth_provider.dart';
import 'package:moj_prijevoz/common/providers/ui_provider.dart';
import 'package:moj_prijevoz/providers/hub_connection.dart';

class AuthInterceptor extends Interceptor {
  final AuthProvider authProvider;
  Future<dynamic>? _refreshFuture;

  AuthInterceptor(this.authProvider);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await AuthProvider.getRefreshToken();
        var accessToken = await AuthProvider.getAccessToken();
        _refreshFuture ??= authProvider.refresh(
          RefreshTokenRequest(
            refreshToken: refreshToken,
            accessToken: accessToken,
          ),
          DioClient.dio,
        );
        await _refreshFuture;
        accessToken = await AuthProvider.getAccessToken();
        final request = err.requestOptions;
        request.headers['Authorization'] = 'Bearer $accessToken';

        final response = await DioClient.dio.fetch(request);
        return handler.resolve(response);
      } catch (_) {
        GetIt.I<UIProvider>().stopLoading();
        await GetIt.I<HubConnectionProvider>().stop();
        await GetIt.I<SharedPrefsProvider>().deleteString(
          Constants.accessTokenKey,
        );
        await Constants.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } finally {
        _refreshFuture = null;
      }
    }
    handler.reject(err);
  }
}
