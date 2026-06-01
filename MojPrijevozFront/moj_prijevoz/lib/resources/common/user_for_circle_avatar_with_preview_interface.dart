import 'dart:io';

import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';

abstract class UserForCircleAvatarWithPreviewInterface
    extends UserForCircleAvatarInterface {
  abstract File? imagePreview;
}
