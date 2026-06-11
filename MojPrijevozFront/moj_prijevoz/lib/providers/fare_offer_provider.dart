import 'package:dio/dio.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_insert_request.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_update_request.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare_offer/fare_offer_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class FareOfferProvider
    extends
        BaseProvider<
          FareResponse,
          FareOfferSearchObject,
          FareOfferInsertRequest,
          FareOfferUpdateRequest
        > {
  final FareProvider fareProvider;
  FareOfferProvider({required this.fareProvider})
    : super(providerName: "fareoffer");

  @override
  Future<FareResponse?> updateWithEvent(
    int id,
    FareOfferUpdateRequest? request, {
    FormData? formData,
  }) async {
    final updatedItem = await super.update(id, request);
    if (updatedItem != null) {
      fareProvider.updateLocally(updatedItem);
      return updatedItem;
    }
    return null;
  }

  Future<FareResponse> accept(int id) async {
    return await httpProvider.post<JsonParsable, FareResponse>(
      "$providerName/$id/accept",
      null,
    );
  }

  Future<FareResponse> acceptWithEvent(int id) async {
    final acceptedItem = await accept(id);
    fareProvider.updateLocally(acceptedItem);
    return acceptedItem;
  }

  Future<FareResponse> reject(int id) async {
    return await httpProvider.post<JsonParsable, FareResponse>(
      "$providerName/$id/reject",
      null,
    );
  }

  Future<FareResponse> rejectWithEvent(int id) async {
    final rejectedItem = await reject(id);
    fareProvider.updateLocally(rejectedItem);

    return rejectedItem;
  }
}
