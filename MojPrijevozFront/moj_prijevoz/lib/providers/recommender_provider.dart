import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/responses/recommender/recommended_driver_response.dart';
import 'package:moj_prijevoz/resources/search_objects/recommended_drivers/recommended_drivers_search_object.dart';

class RecommenderProvider
    extends
        BaseGetProvider<
          RecommendedDriverResponse,
          RecommendedDriversSearchObject
        > {
  RecommenderProvider() : super(providerName: "recommender");
}
