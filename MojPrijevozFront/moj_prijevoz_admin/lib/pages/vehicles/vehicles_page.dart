import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/vehicles/one_vehicle_page.dart';
import 'package:moj_prijevoz_admin/providers/vehicles_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/all_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/vehicle/vehicle_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<StatefulWidget> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends RouteAwareState<VehiclesPage> {
  _VehiclesPageState() : super(action: DrawerMenuAction.vehicles);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Vozila");
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                text: "Dodajte vozilo",
                onPressed: () async => await _navigateToAddVehiclePage(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.screenHeight * 0.8,
          width: context.screenWidth,
          child:
              PaginatedTable<
                AllVehiclesResponse,
                VehicleResponse,
                VehiclesProvider,
                VehicleSearchObject
              >(
                searchObject: VehicleSearchObject(page: 1, pageSize: 10),
                header: <String, String?>{
                  "Proizvođač": "Manufacturer",
                  "Model": "Model",
                  "Kreiran u": "CreatedAt",
                  "Uređen u": "UpdatedAt",
                },

                items: [
                  (i) => Text(i.manufacturer),
                  (i) => Text(i.model),
                  (i) => Text(
                    "${context.getLocalizedDate(i.createdAt)} ${context.getLocalizedTime(i.createdAt)}",
                  ),
                  (i) => Text(
                    "${context.getLocalizedDate(i.updatedAt)} ${context.getLocalizedTime(i.updatedAt)}",
                  ),
                ],
                onTap: (i) async =>
                    await Constants.navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => OneVehiclePage(vehicleId: i!.id),
                      ),
                    ),
              ),
        ),
      ],
    );
  }

  Future _navigateToAddVehiclePage() async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => OneVehiclePage(vehicleId: null)),
    );
  }
}
