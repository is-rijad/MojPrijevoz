import 'package:moj_prijevoz/common/resources/enums/statuses/account_status.dart';

abstract class UserForCircleAvatarInterface {
  abstract String firstName;
  abstract String lastName;
  abstract String? picture;
  abstract AccountStatus status;
}
