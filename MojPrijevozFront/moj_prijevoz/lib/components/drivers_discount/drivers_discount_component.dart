import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_delete_dialog.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/resources/search_objects/drivers_discount/drivers_discount_search_object.dart';
import 'package:moj_prijevoz/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/cards/paginated_cards.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';

class DriversDiscountComponent extends StatefulWidget {
  final int profileId;

  const DriversDiscountComponent({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _DriversDiscountComponent();
}

class _DriversDiscountComponent extends State<DriversDiscountComponent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(double.infinity, 320)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextHeadlineSmall("Moji popusti"),
              PrimaryButton(
                onPressed: () => _buildDiscountUpsertDialog(null),
                text: "Dodaj popust",
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildDiscounts(context),
        ],
      ),
    );
  }

  Widget _buildDiscounts(BuildContext context) {
    return Expanded(
      child:
          PaginatedCards<
            DriversDiscountSearchObject,
            DriversDiscountResponse,
            DriversDiscountProvider
          >(
            searchObject: DriversDiscountSearchObject(page: 1, pageSize: 5),
            onTap: (i) => _buildDiscountUpsertDialog(i),
            onLongPress: (i) => _buildDiscountDeleteDialog(i),
            onSecondaryTap: (i) => _buildDiscountDeleteDialog(i),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            fallbackText: "Nemate popusta",

            children: (i) => [
              const TextTitleMedium("Donja granica kilometara"),
              Divider(color: context.primaryColor),
              TextBodyMedium("${i.minKm} km"),
              SizedBox(height: 12),
              const TextTitleMedium("Gornja granica kilometara"),
              Divider(color: context.primaryColor),
              TextBodyMedium("${i.maxKm ?? "Neograničeno"} km"),

              SizedBox(height: 12),
              const TextTitleMedium("Popust"),
              Divider(color: context.primaryColor),
              TextBodyMedium("${i.discount}%"),
            ],
          ),
    );
  }

  Future<void> _buildDiscountUpsertDialog(
    DriversDiscountResponse? selectedItem,
  ) async {
    await showDialog<DriversDiscountResponse>(
      context: context,
      builder: (context) {
        return DriversDiscountUpsertDialog(selectedItem: selectedItem);
      },
    );
  }

  Future<void> _buildDiscountDeleteDialog(
    DriversDiscountResponse selectedItem,
  ) async {
    await showDialog<DriversDiscountResponse>(
      context: context,
      builder: (context) {
        return DriversDiscountDeleteDialog(selectedItem: selectedItem);
      },
    );
  }
}
