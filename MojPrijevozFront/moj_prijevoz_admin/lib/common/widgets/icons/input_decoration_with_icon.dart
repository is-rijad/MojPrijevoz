import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';

class InputDecorationWithIcon extends InputDecoration {
  final IconData? iconData;
  final String? iconHint;
  InputDecorationWithIcon({
    this.iconData,
    this.iconHint,
    super.border,
    super.hintText,
  }) : super(
         hintStyle: TextStyle(
           color: Constants.placeholderTextColor,
           fontSize: 16,
           fontWeight: FontWeight(400),
         ),
         prefixIcon: Builder(
           builder: (context) {
             if (iconData != null) {
               return Tooltip(
                 message: iconHint ?? "",
                 child: Icon(iconData, color: context.primaryColor),
               );
             } else {
               return SizedBox.shrink();
             }
           },
         ),
       );
}
