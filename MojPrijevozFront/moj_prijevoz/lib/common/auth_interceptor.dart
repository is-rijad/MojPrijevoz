import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/dio_client.dart';
import 'package:moj_prijevoz/common/resources/requests/user/refresh_token_request.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/common/providers/auth_provider.dart';
import 'package:moj_prijevoz/common/providers/ui_provider.dart';

class AuthInterceptor extends Interceptor {
  final AuthProvider authProvider;

  AuthInterceptor(this.authProvider);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await AuthProvider.getRefreshToken();
        var accessToken = await AuthProvider.getAccessToken();
        await authProvider.refresh(
          RefreshTokenRequest(
            refreshToken: refreshToken,
            accessToken: accessToken,
          ),
          DioClient.dio,
        );
        accessToken = await AuthProvider.getAccessToken();
        final request = err.requestOptions;
        request.headers['Authorization'] = 'Bearer $accessToken';

        final response = await DioClient.dio.fetch(request);
        return handler.resolve(response);
      } catch (_) {
        GetIt.I<UIProvider>().stopLoading();
        await Constants.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    }
    handler.reject(err);
  }
}
