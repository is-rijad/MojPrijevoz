import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';

abstract class DeleteDialog<
  TResponse extends JsonResponse,
  TProvider extends BaseProvider
>
    extends StatefulWidget {
  final TResponse selectedItem;
  final String entityName;
  String Function(TResponse selectedItem) itemToString;

  DeleteDialog({
    super.key,
    required this.selectedItem,
    required this.entityName,
    required this.itemToString,
  });

  @override
  State<StatefulWidget> createState() =>
      _DeleteDialogState<TResponse, TProvider>();
}

class _DeleteDialogState<
  TResponse extends JsonResponse,
  TProvider extends BaseProvider
>
    extends State<DeleteDialog<TResponse, TProvider>> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _provider = GetIt.I<TProvider>();

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: "Obriši ${widget.entityName}",
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Da li ste sigurni da želite obrisati ${widget.entityName} ${widget.itemToString.call(widget.selectedItem)}",
            ),
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
          child: const Text("Obriši"),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    try {
      await _provider.delete(widget.selectedItem.id);

      if (!mounted) return;
      Navigator.pop(context, true);
      Constants.messengerKey.currentState!.showSnackBar(
        SuccessSnackBar(message: "Uspješno obrisano!"),
      );
    } on Exception catch (ex, stack) {
      _errorMessage.value = ErrorHandler.handle(ex, stack);
    }
  }
}
