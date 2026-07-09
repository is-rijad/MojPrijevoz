import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/all_users_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/users/users_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class UsersProvider
    extends
        BaseProvider<
          AllUsersResponse,
          UserResponse,
          UsersSearchObject,
          JsonRequest,
          JsonRequest
        > {
  UsersProvider() : super(providerName: "users");
}
