import 'package:flutter/material.dart';

class IconFieldWithText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final String? iconHint;
  final double? width;

  const IconFieldWithText({
    super.key,
    required this.iconData,
    required this.text,
    this.iconHint,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    var icon = Icon(iconData, size: 22);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              baseline: TextBaseline.ideographic,
              alignment: PlaceholderAlignment.baseline,
              child: iconHint != null
                  ? Tooltip(message: iconHint, child: icon)
                  : icon,
            ),
            TextSpan(text: ' $text', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
