import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';

class VehicleProvider
    extends
        BaseGetProvider<VehicleResponse, VehicleResponse, VehicleSearchObject> {
  VehicleProvider({required super.loadingType})
    : super(providerName: "vehicle");
}
