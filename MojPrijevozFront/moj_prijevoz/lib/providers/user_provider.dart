import 'package:moj_prijevoz/common/access_token_handler.dart';
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
  UserProvider({required super.loadingType}) : super(providerName: "user");

  Future<LoginResponse> login(LoginRequest request) async {
    var response = await httpProvider.post<LoginRequest, LoginResponse>(
      "user/login",
      request,
    );
    await AccessTokenHandler.setAccessToken(response.token);
    return response;
  }
}
