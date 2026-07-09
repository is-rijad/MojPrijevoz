import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/city/city_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/all_cities_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/city/city_search_object.dart';

class CityProvider
    extends
        BaseProvider<
          AllCitiesResponse,
          CityResponse,
          CitySearchObject,
          CityUpsertRequest,
          CityUpsertRequest
        > {
  CityProvider() : super(providerName: "city");
}
