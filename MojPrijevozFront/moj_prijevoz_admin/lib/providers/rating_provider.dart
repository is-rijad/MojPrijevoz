import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/rating/rating_update_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/all_ratings_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/rating/rating_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class RatingProvider
    extends
        BaseProvider<
          AllRatingsResponse,
          RatingResponse,
          RatingSearchObject,
          JsonRequest,
          RatingUpdateRequest
        > {
  RatingProvider() : super(providerName: "rating");
}
