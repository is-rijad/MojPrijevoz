import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

class UserProfileProvider
    extends BaseGetProvider<UserProfileResponse, BaseSearchObject> {
  UserProfileProvider() : super(providerName: "userprofile");
}
