import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/resources/requests/user/update_user_request.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';

class UserProvider
    extends
        BaseProvider<
          UserResponse,
          BaseSearchObject,
          CreateUserRequest,
          UpdateUserRequest
        > {
  UserProvider() : super(providerName: "user");
}
