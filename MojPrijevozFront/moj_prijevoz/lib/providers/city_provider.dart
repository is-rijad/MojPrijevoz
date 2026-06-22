import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';

class CityProvider
    extends BaseGetProvider<CityResponse, CitySearchObject> {
  CityProvider() : super(providerName: "city");
}
