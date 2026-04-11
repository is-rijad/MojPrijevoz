import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';

class ConfirmationDialog extends StatefulWidget {
  final Widget content;
  final Future Function() onSubmit;
  final String? successMessage;

  const ConfirmationDialog({
    super.key,
    required this.content,
    required this.onSubmit,
    this.successMessage,
  });

  @override
  State<StatefulWidget> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      content: AlertDialogContent(
        errorMessageValueNotifier: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.content,
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
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await widget.onSubmit.call();
            if (widget.successMessage != null) {
              Constants.messengerKey.currentState!.showSnackBar(
                SuccessSnackBar(message: widget.successMessage!),
              );
            }
          },
          child: const Text("Da"),
        ),
      ],
    );
  }
}
