import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';
import 'package:moj_prijevoz/widgets/dialogs/upsert_dialog.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';

class UserVehicleUpsertDialog
    extends
        UpsertDialog<
          UserVehicleUpsertRequest,
          UserVehicleResponse,
          UserVehicleProvider
        > {
  UserVehicleUpsertDialog({super.key, required super.selectedItem})
    : super(request: UserVehicleUpsertRequest(), entityName: "vozilo");

  @override
  List<Widget> buildContent(BuildContext context, request) {
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
        onSaved: (value) => request.vehicleId = value!.id,
        validator: (value) {
          if (value == null) return "Vozilo je obavezno!";
          return null;
        },
        initialValue: selectedItem?.vehicle,
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
        onSaved: (value) => request.modelYear = int.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Godina proizvodnje je obavezna!";
          }
          if (int.tryParse(value) == null) {
            return "Godina proizvodnje mora biti broj!";
          }
          return null;
        },
        initialValue: selectedItem?.modelYear.toString(),
      ),
      TextFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.numbers,
          iconHint: "Registarske tablice",
        ),
        onSaved: (value) => request.licensePlate = value!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Registarske tablice su obavezne!";
          }
          if (value.length > 9) {
            return "Registarske tablice nisu validne!";
          }
          return null;
        },
        initialValue: selectedItem?.licensePlate,
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
        onSaved: (value) => request.pricePerKm = double.parse(value!),
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
        initialValue: selectedItem?.pricePerKm.toString(),
      ),
    ];
  }
}
