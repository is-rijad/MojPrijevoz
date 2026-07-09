import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/vehicle/vehicle_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/all_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/vehicle/vehicle_search_object.dart';

class VehiclesProvider
    extends
        BaseProvider<
          AllVehiclesResponse,
          VehicleResponse,
          VehicleSearchObject,
          VehicleUpsertRequest,
          VehicleUpsertRequest
        > {
  VehiclesProvider() : super(providerName: "vehicle");
}
