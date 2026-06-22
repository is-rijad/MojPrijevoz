import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';

class VehicleProvider
    extends BaseGetProvider<VehicleResponse, VehicleSearchObject> {
  VehicleProvider() : super(providerName: "vehicle");
}
