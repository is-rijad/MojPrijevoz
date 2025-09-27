import 'package:flutter/material.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';

class MPAlertDialog extends StatelessWidget {
  final String? title;
  final AlertDialogContent content;

  const MPAlertDialog({super.key, this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title ?? ""),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.cancel),
          ),
        ],
      ),
      content: content,
    );
  }
}
