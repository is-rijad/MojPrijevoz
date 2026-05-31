import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';

class MpCard extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final Color? borderColor;
  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  const MpCard({
    super.key,
    required this.onTap,
    required this.children,
    this.onLongPress,
    this.onSecondaryTap,
    this.padding,
    this.spacing,
    this.borderColor,
    this.mainAxisSize,
    this.mainAxisAlignment,
  });

  @override
  State<StatefulWidget> createState() => _MpCardState();
}

class _MpCardState extends State<MpCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Card(
              borderOnForeground: true,
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: widget.borderColor ?? Constants.placeholderTextColor,
                  width: widget.borderColor != null ? 3 : 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 108, 182, 252).withAlpha(100),
                      Constants.primaryButtonTextColor,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.02, 0.95],
                  ),
                ),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(0),
                  child: Column(
                    spacing: widget.spacing ?? 0,
                    mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
                    mainAxisAlignment:
                        widget.mainAxisAlignment ?? MainAxisAlignment.start,
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
