import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/user_vehicles/one_user_vehicle_page.dart';
import 'package:moj_prijevoz_admin/providers/user_vehicles_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/all_user_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class UserVehiclesPage extends StatefulWidget {
  const UserVehiclesPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserVehiclesPageState();
}

class _UserVehiclesPageState extends RouteAwareState<UserVehiclesPage> {
  _UserVehiclesPageState() : super(action: DrawerMenuAction.userVehicles);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: _buildBody(context),
      appBarTitle: "Vozila korisnika",
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.85,
      width: context.screenWidth,
      child:
          PaginatedTable<
            AllUserVehiclesResponse,
            UserVehicleResponse,
            UserVehiclesProvider,
            UserVehicleSearchObject
          >(
            searchObject: UserVehicleSearchObject(page: 1, pageSize: 10),
            header: <String, String?>{
              "Proizvođač": "Vehicle.Manufacturer",
              "Model": "Vehicle.Model",
              "Godina proizvodnje": "ModelYear",
              "Cijena/km": "PricePerKm",
              "Status": "Status",
              "Vlasnik": "Profile.User.FirstName",
            },

            items: [
              (i) => Text(i.vehicle!.manufacturer),
              (i) => Text(i.vehicle!.model),
              (i) => Text(i.modelYear.toString()),
              (i) => Text(i.pricePerKm.toStringAsFixed(2)),

              (i) => Text(userVehicleStatusMap[i.status]!),

              (i) => Text(i.profile!.user!.toString()),
            ],
            onTap: (i) async => await Constants.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => OneUserVehiclePage(userVehicleId: i!.id),
              ),
            ),
          ),
    );
  }
}
