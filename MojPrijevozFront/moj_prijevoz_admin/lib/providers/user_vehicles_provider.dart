import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/user_vehicle/user_vehicle_update_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/all_user_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class UserVehiclesProvider
    extends
        BaseProvider<
          AllUserVehiclesResponse,
          UserVehicleResponse,
          UserVehicleSearchObject,
          JsonRequest,
          UserVehicleUpdateRequest
        > {
  UserVehiclesProvider() : super(providerName: "uservehicles");
}
