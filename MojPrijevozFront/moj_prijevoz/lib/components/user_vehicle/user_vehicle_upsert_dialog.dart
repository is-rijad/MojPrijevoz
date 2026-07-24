import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/image_picker_provider.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/common/widgets/dialogs/upsert_dialog.dart';
import 'package:moj_prijevoz/common/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/common/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/common/widgets/snackbars.dart';
import 'package:provider/provider.dart';

class UserVehicleUpsertDialog
    extends
        UpsertDialog<
          UserVehicleUpsertRequest,
          UserVehicleResponse,
          UserVehicleProvider
        > {
  final String? bankAccountNumber;
  UserVehicleUpsertDialog({
    super.key,
    required super.selectedItem,
    this.bankAccountNumber,
  }) : super(
         request: UserVehicleUpsertRequest(
           bankAccountNumber: bankAccountNumber,
         ),
         entityName: "vozilo",
       );

  final previewImage = ValueNotifier<File?>(null);

  @override
  Future Function(BuildContext, GlobalKey<FormState>) get submitForm =>
      (BuildContext context, GlobalKey<FormState> formKey) async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          JsonResponse? resultItem;

          FormData formData = FormData.fromMap({
            ...super.request.toJson(),
            "picture": super.request.picture,
          });
          if (super.selectedItem != null) {
            resultItem = await context
                .read<UserVehicleProvider>()
                .updateWithEvent(
                  super.selectedItem!.id,
                  null,
                  formData: formData,
                );
          } else {
            resultItem = await context
                .read<UserVehicleProvider>()
                .insertWithEvent(null, formData: formData);
          }
          if (!context.mounted) return;
          previewImage.value = null;
          Constants.navigatorKey.currentState?.pop(resultItem);
          Constants.messengerKey.currentState?.showSnackBar(
            SuccessSnackBar(message: "Uspješno spremljeno!"),
          );
        }
      };
  @override
  List<Widget> buildContent(BuildContext context, request) {
    return [
      GestureDetector(
        onTap: () async => await _onPickImage(context),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: context.screenWidth * 0.4,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Constants.placeholderTextColor,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: ValueListenableBuilder(
                valueListenable: previewImage,
                builder: (context, value, child) {
                  return _getVehiclePicture(context);
                },
              ),
            ),
            Positioned(
              width: 50,
              right: 10,
              top: 0,
              child: Image.asset("images/editImage.png"),
            ),
          ],
        ),
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

  Future<void> _onPickImage(BuildContext context) async {
    final file = await GetIt.I<ImagePickerProvider>().pickImage();
    if (file != null) {
      request.picture = file["picture"];
      previewImage.value = file["file"];
    }
  }

  Image _getVehiclePicture(BuildContext context) {
    if (previewImage.value != null) {
      return Image.file(
        previewImage.value!,
        width: context.screenWidth * 0.3,
        height: context.screenWidth * 0.3,
        fit: BoxFit.fill,
      );
    } else if (selectedItem?.picture != null) {
      return Image.network(
        selectedItem!.picture!,
        width: context.screenWidth * 0.3,
        height: context.screenWidth * 0.3,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset("images/vehiclePlaceholder.png", fit: BoxFit.fill),
      );
    }
    return Image.asset(
      "images/vehiclePlaceholder.png",
      width: context.screenWidth * 0.3,
      height: context.screenWidth * 0.3,
      fit: BoxFit.fill,
    );
  }
}
