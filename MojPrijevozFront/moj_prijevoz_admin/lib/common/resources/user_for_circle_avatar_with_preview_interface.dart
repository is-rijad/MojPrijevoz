import 'dart:io';

import 'package:moj_prijevoz_admin/common/resources/user_for_circle_avatar_interface.dart';

abstract class UserForCircleAvatarWithPreviewInterface
    extends UserForCircleAvatarInterface {
  abstract File? imagePreview;
}
