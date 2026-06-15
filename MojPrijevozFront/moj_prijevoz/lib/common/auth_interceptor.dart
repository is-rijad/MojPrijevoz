import 'package:dio/dio.dart';
import 'package:moj_prijevoz/common/dio_client.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/refresh_token_request.dart';

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
        return handler.reject(err);
      }
    }
    handler.reject(err);
  }
}
