import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/resources/helpers/tplaceholder.dart';
import 'package:moj_prijevoz/resources/responses/auth/auth_response.dart';

class AuthProvider
    extends BaseGetProvider<TPlaceholder, AuthResponse, BaseSearchObject> {
  late AuthResponse _authInfo;
  AuthResponse get authInfo => _authInfo;

  AuthProvider() : super(loadingType: LoadingType.global, providerName: "auth");

  Future<void> setAuthInfo() async {
    _authInfo = await getById(await AccessTokenHandler.getUserId());
  }
}
