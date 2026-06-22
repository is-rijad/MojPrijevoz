import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/common/widgets/dialogs/delete_dialog.dart';

// ignore: must_be_immutable
class UserVehicleDeleteDialog
    extends DeleteDialog<UserVehicleResponse, UserVehicleProvider> {
  UserVehicleDeleteDialog({super.key, required super.selectedItem})
    : super(
        entityName: "vozilo",
        itemToString: (selectedItem) => selectedItem.vehicle.toString(),
      );
}
