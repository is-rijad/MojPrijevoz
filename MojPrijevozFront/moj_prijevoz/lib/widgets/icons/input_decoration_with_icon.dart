import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/build_helper.dart';

class InputDecorationWithIcon extends InputDecoration {
  final IconData? iconData;
  final String? iconHint;
  InputDecorationWithIcon({this.iconData, this.iconHint, super.border})
    : super(
        prefixIcon: Builder(
          builder: (context) {
            if (iconData != null) {
              return Tooltip(
                message: iconHint ?? "",
                child: Icon(
                  iconData,
                  color: BuildHelper.getPrimaryColor(context),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
}
