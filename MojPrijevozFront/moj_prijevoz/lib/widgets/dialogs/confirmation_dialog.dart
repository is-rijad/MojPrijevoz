import 'package:flutter/material.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';

class ConfirmationDialog extends StatefulWidget {
  final String content;
  final Future Function() onSubmit;

  const ConfirmationDialog({
    super.key,
    required this.content,
    required this.onSubmit,
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
            TextTitleMedium(widget.content, textAlign: TextAlign.center),
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
        PrimaryButton(
          onPressed: () async {
            Navigator.pop(context);
            await widget.onSubmit.call();
          },
          text: "Da",
        ),
      ],
    );
  }
}
