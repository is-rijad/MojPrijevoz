import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/resources/helpers/tplaceholder.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/resources/responses/user/login_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';

class UserProvider
    extends
        BaseProvider<
          UserResponse,
          UserResponse,
          BaseSearchObject,
          CreateUserRequest,
          TPlaceholder
        > {
  late final AuthProvider _authProvider;
  UserProvider({required super.loadingType}) : super(providerName: "user") {
    _authProvider = GetIt.I<AuthProvider>();
  }

  Future<LoginResponse> login(LoginRequest request) async {
    var response = await httpProvider.post<LoginRequest, LoginResponse>(
      "user/login",
      request,
    );
    await _authProvider.setAccessToken(response.token);
    return response;
  }
}
