// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';

class AlertDialog extends StatefulWidget {
  String? title;
  String message;
  void Function()? onPressed;
  AlertDialog({
    super.key,
    this.title,
    required this.message,
    required void Function()? onPressed,
  });

  @override
  State<StatefulWidget> createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialog> {
  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: widget.title,
      content: AlertDialogContent(
        errorMessageValueNotifier: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.message),
            SizedBox(height: 20),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Ne"),
        ),
        ElevatedButton(onPressed: widget.onPressed, child: const Text("Da")),
      ],
    );
  }
}
