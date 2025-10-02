import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/drivers_discount/drivers_discount_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/resources/search_objects/drivers_discount/drivers_discount_search_object.dart';

class DriversDiscountProvider
    extends
        BaseProvider<
          DriversDiscountResponse,
          DriversDiscountSearchObject,
          DriversDiscountUpsertRequest,
          DriversDiscountUpsertRequest
        > {
  DriversDiscountProvider() : super(providerName: "driversdiscount");
}
