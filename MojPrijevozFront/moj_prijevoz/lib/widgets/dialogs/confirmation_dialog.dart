import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
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
  final _errorNotifier = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.5),
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorNotifier,
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
            try {
              await widget.onSubmit.call();
            } on Exception catch (e, stack) {
              _errorNotifier.value = ErrorHandler.handle(e, stack);
              await Future.delayed(Duration(seconds: 5));
            }
          },
          text: "Da",
        ),
      ],
    );
  }
}
