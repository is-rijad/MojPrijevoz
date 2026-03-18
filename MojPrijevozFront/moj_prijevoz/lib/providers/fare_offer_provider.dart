import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_insert_request.dart';
import 'package:moj_prijevoz/resources/responses/fare_offer/fare_offer_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare_offer/fare_offer_search_object.dart';

class FareOfferProvider
    extends
        BaseProvider<
          FareOfferResponse,
          FareOfferSearchObject,
          FareOfferInsertRequest,
          FareOfferInsertRequest
        > {
  FareOfferProvider() : super(providerName: "fareoffer");
}
