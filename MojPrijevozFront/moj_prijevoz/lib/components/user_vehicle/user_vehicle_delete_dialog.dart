import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';

class UserVehicleDeleteDialog extends StatefulWidget {
  final UserVehicleResponse selectedVehicle;

  const UserVehicleDeleteDialog({super.key, required this.selectedVehicle});

  @override
  State<StatefulWidget> createState() => _UserVehicleDeleteDialogState();
}

class _UserVehicleDeleteDialogState extends State<UserVehicleDeleteDialog> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _userVehicleProvider = GetIt.I<UserVehicleProvider>();

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: "Obriši vozilo",
      content: _buildContent(context, widget.selectedVehicle),
    );
  }

  AlertDialogContent _buildContent(
    BuildContext context,
    UserVehicleResponse selectedVehicle,
  ) {
    return AlertDialogContent(
      errorMessageValueNotifier: _errorMessage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Da li ste sigurni da želite obrisati vozilo ${selectedVehicle.vehicle.toString()}?",
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Otkaži"),
              ),
              ElevatedButton(
                onPressed: () => _deleteVehicle(selectedVehicle),
                child: const Text("Obriši"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVehicle(UserVehicleResponse selectedVehicle) async {
    try {
      await _userVehicleProvider.delete(selectedVehicle.id);
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
