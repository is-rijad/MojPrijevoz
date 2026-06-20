import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:provider/provider.dart';

abstract class UpsertDialog<
  TRequest extends JsonRequest,
  TResponse extends JsonResponse,
  TProvider extends BaseProvider
>
    extends StatefulWidget {
  final TResponse? selectedItem;
  final TRequest request;
  final String entityName;
  final Future Function(BuildContext context, GlobalKey<FormState> formKey)?
  submitForm;

  List<Widget> buildContent(BuildContext context, TRequest request);

  const UpsertDialog({
    super.key,
    required this.selectedItem,
    required this.request,
    required this.entityName,
    this.submitForm,
  });

  @override
  State<StatefulWidget> createState() =>
      _UpsertDialogState<TRequest, TResponse, TProvider>();
}

class _UpsertDialogState<
  TRequest extends JsonRequest,
  TResponse extends JsonResponse,
  TProvider extends BaseProvider
>
    extends State<UpsertDialog> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: widget.selectedItem != null
          ? "Uredi ${widget.entityName}"
          : "Dodaj ${widget.entityName}",
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: FormWrapper(
          paddingFactor: 0.02,
          screenWidthFactor: 0.9,
          formKey: _formKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.buildContent(context, widget.request),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Otkaži"),
        ),
        PrimaryButton(
          onPressed: () => _submitForm(),
          text: widget.selectedItem != null ? "Spremi" : "Dodaj",
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (widget.submitForm != null) {
      try {
        return await widget.submitForm!.call(context, _formKey);
      } on Exception catch (e, stack) {
        _errorMessage.value = ErrorHandler.handle(e, stack);
        await Future.delayed(Duration(seconds: 5));
      }
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        JsonResponse? resultItem;

        if (widget.selectedItem != null) {
          resultItem = await context.read<TProvider>().updateWithEvent(
            widget.selectedItem!.id,
            widget.request,
          );
        } else {
          resultItem = await context.read<TProvider>().insertWithEvent(
            widget.request,
          );
        }
        if (!mounted) return;
        Navigator.pop(context, resultItem);
        Constants.messengerKey.currentState!.showSnackBar(
          SuccessSnackBar(message: "Uspješno spremljeno!"),
        );
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }
}
