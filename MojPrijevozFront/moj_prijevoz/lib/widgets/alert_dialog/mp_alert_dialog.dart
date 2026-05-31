import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';

class MPAlertDialog extends StatelessWidget {
  final String? title;
  final AlertDialogContent content;

  const MPAlertDialog({super.key, this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 6,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextTitleMedium(title ?? ""),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset("images/iconClose.png"),
          ),
        ],
      ),
      content: content,
    );
  }
}
