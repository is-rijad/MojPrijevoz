import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
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
      Stack(
        children: [
          Container(
            width: context.screenWidth * 0.5,
            decoration: BoxDecoration(
              border: Border.all(
                color: Constants.placeholderTextColor,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: request.picture != null
                ? Image.network(request.picture!)
                : Image.asset("images/vehiclePlaceholder.png"),
          ),
          Positioned(
            width: 50,
            right: 10,
            top: 0,
            child: Image.asset("images/editImage.png"),
          ),
        ],
      ),

      SizedBox(height: 12),
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
          hintText: "Audi Q3",
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
          hintText: "2022",
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
          hintText: "A12-E-345",
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
          iconData: Icons.attach_money,
          iconHint: "Cijena po kilometru",
          hintText: "0.5",
        ).copyWith(suffixText: "KM"),
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
