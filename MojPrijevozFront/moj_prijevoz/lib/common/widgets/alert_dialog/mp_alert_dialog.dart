import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';

class MPAlertDialog extends StatelessWidget {
  final String? title;
  final AlertDialogContent content;
  final BoxConstraints? constraints;

  const MPAlertDialog({
    super.key,
    this.title,
    required this.content,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: constraints,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 108, 182, 252),
              Constants.primaryButtonTextColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.02, 0.95],
          ),
        ),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextTitleMedium(title ?? ""),
              IconButton(
                onPressed: () => Constants.navigatorKey.currentState?.pop(),
                icon: Image.asset("images/iconClose.png"),
              ),
            ],
          ),
          content: content,
        ),
      ),
    );
  }
}
