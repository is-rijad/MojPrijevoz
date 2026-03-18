import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_driver_response.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_search_object.dart';

class SearchFareProvider
    extends BaseGetProvider<SearchFareResponse, SearchFareSearchObject> {
  SearchFareProvider() : super(providerName: "searchfare");

  final _httpProvider = GetIt.I<HttpProvider>();
  final Map<int, SearchFareDriverResponse> fareDrivers =
      <int, SearchFareDriverResponse>{};

  void clearFareDrivers() {
    fareDrivers.clear();
    notifyListeners();
  }

  Future<void> fetchFareDriver(
    int id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _httpProvider.getSingle<SearchFareDriverResponse>(
      providerName,
      id: id,
      queryParameters: queryParameters,
    );
    fareDrivers[id] = response;

    notifyListeners();
  }
}
