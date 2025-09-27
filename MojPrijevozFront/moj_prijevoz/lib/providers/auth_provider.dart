import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/resources/responses/user/access_token_response.dart';

class AuthProvider {
  late final HttpProvider _httpProvider;
  final providerName = "auth";
  AuthProvider() {
    _httpProvider = GetIt.I<HttpProvider>();
  }

  Future<AccessTokenResponse> login(LoginRequest request) async {
    return await _httpProvider.post<LoginRequest, AccessTokenResponse>(
      providerName,
      request,
    );
  }

  Future<AccessTokenResponse> getNewToken() async {
    return await _httpProvider.getSingle<AccessTokenResponse>(providerName);
  }
}
