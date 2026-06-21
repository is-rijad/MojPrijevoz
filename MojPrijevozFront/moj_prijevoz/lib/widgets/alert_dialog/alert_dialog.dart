// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';

import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';

class AlertDialog extends StatefulWidget {
  final String? title;
  final String message;
  final Future Function()? onPressed;
  const AlertDialog({
    super.key,
    this.title,
    required this.message,
    required this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialog> {
  final _errorNotifier = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: widget.title,
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorNotifier,
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
          onPressed: () => Constants.navigatorKey.currentState?.pop(),
          child: const Text("Ne"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (widget.onPressed != null) {
              try {
                await widget.onPressed!.call();
              } on Exception catch (e, stack) {
                _errorNotifier.value = ErrorHandler.handle(e, stack);
                await Future.delayed(Duration(seconds: 5));
              }
            }
          },
          child: const Text("Da"),
        ),
      ],
    );
  }
}
