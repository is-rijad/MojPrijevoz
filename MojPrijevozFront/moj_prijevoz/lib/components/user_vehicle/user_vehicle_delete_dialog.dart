import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/widgets/dialogs/delete_dialog.dart';

class UserVehicleDeleteDialog
    extends DeleteDialog<UserVehicleResponse, UserVehicleProvider> {
  UserVehicleDeleteDialog({super.key, required super.selectedItem})
    : super(
        entityName: "vozilo",
        itemToString: (selectedItem) => selectedItem.vehicle.toString(),
      );
}
