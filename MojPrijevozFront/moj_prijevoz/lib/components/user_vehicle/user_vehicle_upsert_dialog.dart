import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';

class UserVehicleUpsertDialog extends StatefulWidget {
  final UserVehicleResponse? selectedVehicle;

  const UserVehicleUpsertDialog({super.key, this.selectedVehicle});

  @override
  State<StatefulWidget> createState() => _UserVehicleUpsertDialogState();
}

class _UserVehicleUpsertDialogState extends State<UserVehicleUpsertDialog> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  UserVehicleUpsertRequest? _userVehicleUpsertRequest;
  final _userVehicleProvider = GetIt.I<UserVehicleProvider>();

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: FormWrapper(
          formKey: _formKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildVehicleUpsertForm(context, widget.selectedVehicle),
        ),
      ),
    );
  }

  List<Widget> _buildVehicleUpsertForm(
    BuildContext context,
    UserVehicleResponse? selectedVehicle,
  ) {
    _userVehicleUpsertRequest = UserVehicleUpsertRequest();
    return [
      PagedDropdownFormField<
        VehicleResponse,
        int,
        VehicleProvider,
        VehicleSearchObject
      >(
        searchObject: VehicleSearchObject(page: 1, pageSize: 10),
        getLabel: (i) => i.toString(),
        getValue: (i) => i.id,
        decoration: InputDecorationWithIcon(
          iconData: Icons.directions_car_filled,
          iconHint: "Vozilo",
        ),
        onSaved: (value) => _userVehicleUpsertRequest!.vehicleId = value!.id,
        validator: (value) {
          if (value == null) return "Vozilo je obavezno!";
          return null;
        },
        initialValue: selectedVehicle?.vehicle,
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.calendar_month,
          iconHint: "Godina proizvodnje",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.modelYear = int.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Godina proizvodnje je obavezna!";
          }
          if (int.tryParse(value) == null) {
            return "Godina proizvodnje mora biti broj!";
          }
          return null;
        },
        initialValue: selectedVehicle?.modelYear.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.local_gas_station,
          iconHint: "Prosječna potrošnja goriva",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.fuelConsumption = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Prosječna potrošnja goriva je obavezna!";
          }
          if (double.tryParse(value) == null) {
            return "Prosječna potrošnja goriva mora biti broj!";
          }
          if (double.parse(value) < 0 || double.parse(value) > 50) {
            return "Prosječna potrošnja goriva ne smije biti manja od 0, ni veća od 50!";
          }
          return null;
        },
        initialValue: selectedVehicle?.fuelConsumption.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.money,
          iconHint: "Cijena po kilometru",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.pricePerKm = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Cijena po kilometru je obavezna!";
          }
          if (double.tryParse(value) == null) {
            return "Cijena po kilometru mora biti broj!";
          }
          if (double.parse(value) < 0 || double.parse(value) > 10) {
            return "Cijena po kilometru ne smije biti manja od 0, ni veća od 10!";
          }
          return null;
        },
        initialValue: selectedVehicle?.pricePerKm.toString(),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _submitForm(selectedVehicle),
        child: selectedVehicle != null
            ? const Text("Spremi promjene")
            : const Text("Dodaj vozilo"),
      ),
    ];
  }

  Future<void> _submitForm(UserVehicleResponse? selectedVehicle) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserVehicleResponse? resultItem;

        if (selectedVehicle != null) {
          resultItem = await _userVehicleProvider.update(
            selectedVehicle.id,
            _userVehicleUpsertRequest!,
          );
        } else {
          resultItem = await _userVehicleProvider.insert(
            _userVehicleUpsertRequest!,
          );
        }
        if (!mounted) return;
        Navigator.pop(context, resultItem);
        Constants.messengerKey.currentState!.showSnackBar(
          SuccessSnackBar(message: "Uspješno spremljeno!"),
        );
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
      }
    }
  }
}
