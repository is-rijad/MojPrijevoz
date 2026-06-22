import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/rating/rating_insert_request.dart';
import 'package:moj_prijevoz/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz/resources/search_objects/rating/rating_search_object.dart';

class RatingProvider
    extends
        BaseProvider<
          RatingResponse,
          RatingSearchObject,
          RatingInsertRequest,
          RatingInsertRequest
        > {
  RatingProvider() : super(providerName: "rating");
}
