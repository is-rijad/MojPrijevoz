import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';

abstract class UpsertDialog<
  TRequest extends JsonRequest,
  TResponse extends JsonResponse,
  TProvider extends BaseProvider
>
    extends StatefulWidget {
  final TResponse? selectedItem;
  final TRequest request;
  final String entityName;

  List<Widget> buildContent(BuildContext context, TRequest request);

  const UpsertDialog({
    super.key,
    required this.selectedItem,
    required this.request,
    required this.entityName,
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
  final _provider = GetIt.I<TProvider>();

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: widget.selectedItem != null
          ? "Uredi ${widget.entityName}"
          : "Dodaj ${widget.entityName}",
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: FormWrapper(
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Otkaži"),
        ),
        ElevatedButton(
          onPressed: () => _submitForm(),
          child: widget.selectedItem != null
              ? const Text("Spremi")
              : const Text("Dodaj"),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        JsonResponse? resultItem;

        if (widget.selectedItem != null) {
          resultItem = await _provider.update(
            widget.selectedItem!.id,
            widget.request,
          );
        } else {
          resultItem = await _provider.insert(widget.request);
        }
        if (!mounted) return;
        Navigator.pop(context, resultItem as TResponse);
        Constants.messengerKey.currentState!.showSnackBar(
          SuccessSnackBar(message: "Uspješno spremljeno!"),
        );
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
      }
    }
  }
}
