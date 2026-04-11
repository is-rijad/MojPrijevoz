import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_insert_request.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_update_request.dart';
import 'package:moj_prijevoz/resources/responses/fare_offer/fare_offer_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare_offer/fare_offer_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class FareOfferProvider
    extends
        BaseProvider<
          FareOfferResponse,
          FareOfferSearchObject,
          FareOfferInsertRequest,
          FareOfferUpdateRequest
        > {
  FareOfferProvider() : super(providerName: "fareoffer");

  Future<FareOfferResponse> accept(int id) async {
    return await httpProvider.post<JsonParsable, FareOfferResponse>(
      "$providerName/$id/accept",
      null,
    );
  }

  Future<FareOfferResponse> reject(int id) async {
    return await httpProvider.post<JsonParsable, FareOfferResponse>(
      "$providerName/$id/reject",
      null,
    );
  }
}
