import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_delete_dialog.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/resources/search_objects/drivers_discount/drivers_discount_search_object.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';

class DriversDiscountComponent extends StatefulWidget {
  final int profileId;

  const DriversDiscountComponent({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _DriversDiscountComponent();
}

class _DriversDiscountComponent extends State<DriversDiscountComponent> {
  final double _itemExtent = 50;
  final int _pageSize = 5;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(context.screenWidth, _itemExtent * (_pageSize - 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Moji popusti"),
              ElevatedButton(
                onPressed: () => _buildDiscountUpsertDialog(null),
                child: const Text("Dodaj popust"),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildList(context),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child:
          PaginatedTable<
            DriversDiscountResponse,
            DriversDiscountProvider,
            DriversDiscountSearchObject
          >(
            pageSize: _pageSize,
            onTap: _buildDiscountUpsertDialog,
            onSecondaryOrLongPress: _buildDiscountDeleteDialog,
            searchObject: DriversDiscountSearchObject(
              page: 1,
              pageSize: _pageSize,
            ),
            header: [
              "Donja granica kilometara",
              "Gornja granica kilometara",
              "Popust",
            ],
            items: [
              (i) => Text("${i.minKm} km"),
              (i) => Text("${i.maxKm?.toString() ?? "Neograničeno"} km"),
              (i) => Text("${i.discount}%"),
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
