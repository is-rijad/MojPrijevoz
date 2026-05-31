import 'package:flutter/material.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';

class Avatar extends CircleAvatar {
  final UserForCircleAvatarInterface user;
  final bool showAccountStatus;
  final double? fontSize;
  Avatar({
    required this.user,
    this.fontSize,
    this.showAccountStatus = false,
    super.key,
    super.radius,
    super.maxRadius,
    super.minRadius,
  }) : super(child: _getChild(user, showAccountStatus, fontSize));

  static Widget _getChild(
    UserForCircleAvatarInterface user,
    bool showAccountStatus,
    double? fontSize,
  ) {
    if (showAccountStatus &&
        (user.status == AccountStatus.waitingForChanges ||
            user.status == AccountStatus.waitingForReview)) {
      assert(showAccountStatus && fontSize != null);
      return Banner(
        message: accountStatusMap[user.status]!,
        location: BannerLocation.bottomStart,
        color: Colors.red,
        textStyle: TextStyle(fontSize: fontSize),
        child: _getUserPicture(user),
      );
    }
    return _getUserPicture(user);
  }

  static Widget _getUserPicture(UserForCircleAvatarInterface user) {
    return user.picture == null
        ? Text(user.firstName[0] + user.lastName[0])
        : Image.network(
            user.picture!,
            errorBuilder: (context, error, stackTrace) =>
                Text(user.firstName[0] + user.lastName[0]),
          ); // TODO: fix image
  }
}
