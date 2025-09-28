import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/widgets/dialogs/delete_dialog.dart';

class DriversDiscountDeleteDialog
    extends DeleteDialog<DriversDiscountResponse, DriversDiscountProvider> {
  DriversDiscountDeleteDialog({super.key, required super.selectedItem})
    : super(
        entityName: "popust",
        itemToString: (selectedItem) => selectedItem.toString(),
      );
}
