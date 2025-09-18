import 'package:flutter/material.dart';

class InputDecorationWithIcon extends InputDecoration {
  final IconData? iconData;
  final String? iconHint;
  InputDecorationWithIcon({this.iconData, this.iconHint, super.border})
    : super(
        prefixIcon: Builder(
          builder: (ctx) {
            if (iconData != null) {
              return Tooltip(
                message: iconHint ?? "",
                child: Icon(iconData, color: Theme.of(ctx).colorScheme.primary),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
}
