import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_delete_dialog.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/drivers_discount/drivers_discount_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/cards/mp_card.dart';
import 'package:moj_prijevoz/widgets/cards/paginated_cards.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class UserVehiclesComponent extends StatefulWidget {
  final int profileId;
  const UserVehiclesComponent({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _UserVehiclesComponentState();
}

class _UserVehiclesComponentState extends State<UserVehiclesComponent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(double.infinity, 350)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextHeadlineSmall("Moja vozila"),
              PrimaryButton(
                onPressed: () => _buildVehicleUpsertDialog(context, null),
                text: "Dodaj vozilo",
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildVehicles(context),
        ],
      ),
    );
  }

  Future<void> _buildVehicleUpsertDialog(
    BuildContext context,
    UserVehicleResponse? selectedVehicle,
  ) async {
    await showDialog<UserVehicleResponse>(
      context: context,
      builder: (BuildContext context) {
        return UserVehicleUpsertDialog(selectedItem: selectedVehicle);
      },
    );
  }

  Widget _buildVehicles(BuildContext context) {
    return Expanded(
      child:
          PaginatedCards<
            UserVehicleSearchObject,
            UserVehicleResponse,
            UserVehicleProvider
          >(
            searchObject: UserVehicleSearchObject(
              page: 1,
              pageSize: 5,
              profileId: widget.profileId,
            ),
            fallbackText: "Nemate vozila!",
            onTap: (i) => _buildVehicleUpsertDialog(context, i),
            onLongPress: (i) => _buildVehicleDeleteDialog(context, i),
            onSecondaryTap: (i) => _buildVehicleDeleteDialog(context, i),
            padding: const EdgeInsets.symmetric(vertical: 8),
            banner: (i) => userVehicleStatusMap[i.status]!,
            children: (i) => [
              TextHeadlineSmall("${i.vehicle.manufacturer} ${i.vehicle.model}"),
              _buildVehiclePicture(context, i),
              IconFieldWithText(
                width: 100,
                iconData: Icons.calendar_month,
                text: "${i.modelYear}.",
                iconHint: "Godina proizvodnje",
              ),
              IconFieldWithText(
                width: 100,

                iconData: Icons.numbers,
                text: i.licensePlate,
                iconHint: "Registarske tablice",
              ),
              IconFieldWithText(
                width: 100,
                iconData: Icons.attach_money,
                text: "${i.pricePerKm.toString()} KM/km",
                iconHint: "Cijena po kilometru",
              ),
            ],
          ),
    );
  }

  Widget _buildVehiclePicture(
    BuildContext context,
    UserVehicleResponse userVehicle,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Constants.placeholderTextColor, width: 2),
        shape: BoxShape.circle,
      ),
      child: userVehicle.picture != null
          ? Image.network(userVehicle.picture!)
          : Image.asset("images/vehiclePlaceholder.png"),
    );
  }

  Future<void> _buildVehicleDeleteDialog(
    BuildContext context,
    UserVehicleResponse selectedVehicle,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return UserVehicleDeleteDialog(selectedItem: selectedVehicle);
      },
    );
  }
}
