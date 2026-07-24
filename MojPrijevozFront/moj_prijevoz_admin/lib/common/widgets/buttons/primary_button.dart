import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade400 : context.primaryColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDisabled ? Colors.grey.shade500 : const Color(0xff559bd6),
            width: 1,
          ),
          boxShadow: isDisabled
              ? []
              : [
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
          child: Opacity(
            opacity: isDisabled ? 0.6 : 1.0,
            child: TextTitleSmall(text),
          ),
        ),
      ),
    );
  }
}
