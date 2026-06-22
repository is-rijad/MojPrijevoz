import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';

class UserVehicleProvider
    extends
        BaseProvider<
          UserVehicleResponse,
          UserVehicleSearchObject,
          UserVehicleUpsertRequest,
          UserVehicleUpsertRequest
        > {
  UserVehicleProvider() : super(providerName: "uservehicle");
}
