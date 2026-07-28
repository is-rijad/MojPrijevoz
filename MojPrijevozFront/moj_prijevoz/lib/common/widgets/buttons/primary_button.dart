import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final FutureOr<void> Function()? onPressed;

  const PrimaryButton({super.key, this.onPressed, required this.text});

  @override
  State<StatefulWidget> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (!_isLoading && widget.onPressed != null)
          ? () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await widget.onPressed!.call();
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xff559bd6), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Color(0xff2d6694),
              blurRadius: 0,
              offset: Offset(1.5, 2),
              spreadRadius: -0.5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.secondaryColor,
                  ),
                )
              : TextTitleSmall(widget.text),
        ),
      ),
    );
  }
}
