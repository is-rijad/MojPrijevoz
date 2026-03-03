import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_search_object.dart';

class SearchFareProvider
    extends BaseGetProvider<UserResponse, SearchFareSearchObject> {
  SearchFareProvider() : super(providerName: "searchfare");
}
