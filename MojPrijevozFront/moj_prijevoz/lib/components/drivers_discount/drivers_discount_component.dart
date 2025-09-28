import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/drivers_discount_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/resources/search_objects/drivers_discount/drivers_discount_search_object.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';

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
        Size(double.infinity, _itemExtent * (_pageSize - 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Moji popusti"),
              ElevatedButton(
                onPressed: () => true,
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
    return PaginatedTable<
      DriversDiscountResponse,
      DriversDiscountProvider,
      DriversDiscountSearchObject
    >(
      pageSize: _pageSize,

      searchObject: DriversDiscountSearchObject(page: 1, pageSize: _pageSize),
      header: [
        "Donja granica kilometara",
        "Gornja granica kilometara",
        "Popust",
      ],
      items: [
        (i) => "${i.minKm} km",
        (i) => "${i.maxKm?.toString() ?? "Neograničeno"} km",
        (i) => "${i.discount}%",
      ],
    );
  }

  Future<void> _buildDiscountUpsertDialog(
    DriversDiscountResponse? selectedItem,
    SearchResult<DriversDiscountResponse> items,
  ) async {
    final result = await showDialog<DriversDiscountResponse>(
      context: context,
      builder: (context) {
        return DriversDiscountUpsertDialog(selectedItem: selectedItem);
      },
    );
    if (result != null && mounted) {
      if (selectedItem != null) {
        var selectedIndex = items.items.indexOf(selectedItem);
        setState(() {
          items.items[selectedIndex] = result;
        });
      } else {
        setState(() {
          items.items.add(result);
        });
      }
    }
  }
}
