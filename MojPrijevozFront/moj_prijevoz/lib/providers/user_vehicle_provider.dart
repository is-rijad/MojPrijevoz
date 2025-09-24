import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';

class UserVehicleProvider
    extends
        BaseProvider<
          UserVehicleResponse,
          UserVehicleResponse,
          UserVehicleSearchObject,
          UserVehicleUpsertRequest,
          UserVehicleUpsertRequest
        > {
  UserVehicleProvider({required super.loadingType})
    : super(providerName: "uservehicle");
}
