import 'package:flutter/material.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';

class Avatar extends CircleAvatar {
  final UserForCircleAvatarInterface? user;
  Avatar({
    required this.user,
    super.key,
    super.radius,
    super.maxRadius,
    super.minRadius,
  }) : super(
         child: user?.picture == null
             ? Text((user?.firstName[0] ?? "") + (user?.lastName[0] ?? ""))
             : Image.network(user!.picture!),
       );
}
