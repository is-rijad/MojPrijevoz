import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';

class CityProvider
    extends BaseGetProvider<CityResponse, CityResponse, CitySearchObject> {
  CityProvider({required super.loadingType}) : super(providerName: "city");
}
