import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';

class GeneralDialog<TResponse, TRequest> extends StatefulWidget {
  final Future<TResponse> Function()? onInit;
  final TResponse? entity;
  final Future Function() onSubmit;
  final String title;
  final String submitButtonTitle;
  final List<Widget> Function()? buildButtons;
  final String? successMessage;
  final List<Widget> Function(BuildContext, TResponse) buildContent;

  const GeneralDialog({
    super.key,
    required this.title,
    this.onInit,
    required this.onSubmit,
    required this.submitButtonTitle,
    this.successMessage,
    this.buildButtons,
    required this.buildContent,
    this.entity,
  });

  @override
  State<StatefulWidget> createState() =>
      _GeneralDialogState<TResponse, TRequest>();
}

class _GeneralDialogState<TResponse, TRequest>
    extends State<GeneralDialog<TResponse, TRequest>> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  late final TResponse loadedEntity;
  @override
  void didUpdateWidget(covariant GeneralDialog<TResponse, TRequest> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.submitButtonTitle != oldWidget.submitButtonTitle) {
      setState(() {
        widget.submitButtonTitle;
      });
    }
    if (widget.successMessage != oldWidget.successMessage) {
      setState(() {
        widget.successMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.onInit != null || widget.entity != null);

    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return MPAlertDialog(
      title: widget.title,
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: FormWrapper(
          formKey: _formKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.buildContent.call(context, loadedEntity),
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
        if (widget.buildButtons == null)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
        if (widget.buildButtons != null) ...widget.buildButtons!.call(),
        ElevatedButton(
          onPressed: () => _submitForm(),
          child: Text(widget.submitButtonTitle),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        JsonResponse? resultItem;

        await widget.onSubmit.call();
        if (!mounted) return;
        Navigator.pop(context, resultItem);
        if (widget.successMessage != null) {
          Constants.messengerKey.currentState!.showSnackBar(
            SuccessSnackBar(message: widget.successMessage!),
          );
        }
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
      }
    }
  }

  Future<bool> _init() async {
    loadedEntity = await widget.onInit?.call() ?? widget.entity!;
    return true;
  }
}
