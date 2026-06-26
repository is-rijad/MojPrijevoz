import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/resources/user_for_circle_avatar_interface.dart';

class Avatar extends StatefulWidget {
  final UserForCircleAvatarInterface user;
  final bool showAccountStatus;
  final double? fontSize;
  final double? radius;
  final double? maxRadius;
  final double? minRadius;
  const Avatar({
    required this.user,
    this.fontSize,
    this.showAccountStatus = false,
    super.key,
    this.radius,
    this.maxRadius,
    this.minRadius,
  });

  @override
  State<StatefulWidget> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final child = CircleAvatar(
      foregroundImage: _getUserPicture(widget.user),
      radius: widget.radius,
      maxRadius: widget.maxRadius,
      minRadius: widget.minRadius,
      child: Text(widget.user.firstName[0] + widget.user.lastName[0]),
    );
    if (widget.showAccountStatus &&
        (widget.user.status == AccountStatus.waitingForChanges ||
            widget.user.status == AccountStatus.waitingForReview)) {
      assert(widget.showAccountStatus && widget.fontSize != null);
      return Banner(
        message: accountStatusMap[widget.user.status]!,
        location: BannerLocation.topEnd,
        color: context.primaryColor,
        textStyle: TextStyle(fontSize: widget.fontSize),
        child: child,
      );
    }
    return child;
  }

  ImageProvider<Object>? _getUserPicture(UserForCircleAvatarInterface user) {
    try {
      return user.picture != null ? NetworkImage(user.picture!) : null;
    } catch (_) {
      return null;
    }
  }
}
