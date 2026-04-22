import 'dart:async';

import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/helpers/tplaceholder.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class FareProvider
    extends
        BaseProvider<
          FareResponse,
          FareSearchObject,
          TPlaceholderRequest,
          TPlaceholderRequest
        > {
  FareProvider() : super(providerName: "fare");
  final fareStartTimers = <int, Timer>{};
  final nextFares = SearchResult<FareResponse>();

  @override
  Future<void> fetchData(FareSearchObject searchObject) async {
    await super.fetchData(searchObject);
    for (var fare in searchResult.items) {
      if (fare.fareStartAfter != null) {
        final remaining = fare.fareStartAfter!.difference(DateTime.now());
        if (!remaining.isNegative) {
          fareStartTimers[fare.id] = Timer(
            remaining,
            () => makeFareStartAvailable(fare),
          );
        } else {
          makeFareStartAvailable(fare);
        }
      }
    }
  }

  void makeFareStartAvailable(FareResponse fare) {
    searchResult.items.where((it) => it.id == fare.id).first.isStartAvailable =
        true;
    notifyListeners();
  }

  @override
  void clearData(FareSearchObject searchObject) {
    super.clearData(searchObject);
    fareStartTimers.clear();
  }

  Future<FareResponse> start(int id) async {
    final fare = await httpProvider.post<JsonParsable, FareResponse>(
      "$providerName/$id/start",
      null,
    );
    updateLocally(fare);
    return fare;
  }

  Future<void> fetchNextFares(FareSearchObject searchObject) async {
    if (searchObject.page == 0 || searchObject.page == 1) {
      nextFares.items.clear();
    }
    uiProvider.disableLoading();
    final newItems = await httpProvider.getAll<FareResponse, FareSearchObject>(
      "$providerName/next",
      searchObject,
    );
    newItems.copyTo(nextFares);
    searchObject.page++;
    notifyListeners();
  }
}
