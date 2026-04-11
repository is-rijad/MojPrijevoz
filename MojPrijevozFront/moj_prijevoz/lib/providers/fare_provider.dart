import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';

class FareProvider extends BaseGetProvider<FareResponse, FareSearchObject> {
  FareProvider() : super(providerName: "fare");
}
