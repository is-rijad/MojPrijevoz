import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/resources/requests/drivers_discount/drivers_discount_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/widgets/dialogs/upsert_dialog.dart';

class DriversDiscountUpsertDialog
    extends
        UpsertDialog<
          DriversDiscountUpsertRequest,
          DriversDiscountResponse,
          DriversDiscountProvider
        > {
  DriversDiscountUpsertDialog({super.key, required super.selectedItem})
    : super(request: DriversDiscountUpsertRequest(), entityName: "popust");

  @override
  List<Widget> buildContent(BuildContext context, request) {
    return [
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecoration(hintText: "Minimum kilometara"),
        onSaved: (value) => request.minKm = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Donja granica kilometara je obavezna!";
          }
          if (double.tryParse(value) == null) {
            return "Donja granica kilometara mora biti broj!";
          }
          if (double.parse(value) < 0) {
            return "Donja granica kilometara ne smije biti manja od 0!";
          }
          return null;
        },
        initialValue: selectedItem?.minKm.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecoration(hintText: "Maksimum kilometara"),
        onSaved: (value) => request.maxKm = double.tryParse(value!),
        validator: (value) {
          if (value != null &&
              value.isNotEmpty &&
              double.tryParse(value) == null) {
            return "Gornja granica kilometara mora biti broj!";
          }
          return null;
        },
        initialValue: selectedItem?.maxKm?.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecoration(hintText: "Popust u procentima"),
        onSaved: (value) => request.discount = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Popust u procentima je obavezan!";
          }
          if (double.tryParse(value) == null) {
            return "Popust u procentima mora biti broj!";
          }
          if (double.parse(value) < 0 || double.parse(value) > 100) {
            return "Popust u procentima ne smije biti manji od 0, ni veći od 100!";
          }
          return null;
        },
        initialValue: selectedItem?.discount.toString(),
      ),
    ];
  }
}
