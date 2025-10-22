import 'package:dio/dio.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class NominatimProvider
    extends BaseGetProvider<NominatimResponse, NominatimSearchObject> {
  final _nominatimApiUrl = Environment.nominatimApiUrl;
  final _excludeIds = <int>[];
  final _dio = Dio();
  final _limit = 5;

  NominatimProvider() : super(providerName: "nominatim");

  @override
  Future<void> fetchData(NominatimSearchObject searchObject) async {
    if (searchObject.contains != null) {
      await fetchCoords(searchObject);
    }
    notifyListeners();
  }

  @override
  void clearData(NominatimSearchObject searchObject) {
    _excludeIds.clear();
    super.clearData(searchObject);
  }

  Future<void> fetchCoords(NominatimSearchObject searchObject) async {
    dynamic response;
    if (searchObject.selectedPlaceId != null &&
        searchObject.selectedPlaceType != null) {
      response = await _fetchById(searchObject);
    } else if (searchObject.contains != null) {
      response = await _fetchByQuery(searchObject);
    } else {
      throw Exception("PlaceId or SearchQuery is not configured!");
    }
    _convertResponse(response);
  }

  Future<dynamic> _fetchByQuery(NominatimSearchObject searchObject) async {
    final url = "${_nominatimApiUrl}search";
    final response = await _dio.get(
      url,
      options: _setRequestOptions(),
      queryParameters: _includeQueryParamsForQuerySearch(searchObject),
    );
    return response;
  }

  Future<dynamic> _fetchById(NominatimSearchObject searchObject) async {
    final url = "${_nominatimApiUrl}lookup";
    final response = await _dio.get(
      url,
      options: _setRequestOptions(),
      queryParameters: _includeQueryParamsForIdSearch(searchObject),
    );
    return response;
  }

  Options _setRequestOptions() {
    var options = Options(contentType: "application/json");
    var headersMap = <String, dynamic>{"User-Agent": Constants.userAgent};
    options.headers = headersMap;
    return options;
  }

  Map<String, dynamic> _includeQueryParamsForIdSearch(
    NominatimSearchObject searchObject,
  ) {
    Map<String, dynamic> queryParams = <String, dynamic>{};
    queryParams.addEntries(
      <String, dynamic>{
        "osm_ids":
            "${searchObject.selectedPlaceType![0]}${searchObject.selectedPlaceId!}",
        "format": "json",
        "accept-language": "bs",
      }.entries,
    );
    return queryParams;
  }

  Map<String, dynamic> _includeQueryParamsForQuerySearch(
    NominatimSearchObject searchObject,
  ) {
    Map<String, dynamic> queryParams = <String, dynamic>{};
    queryParams.addEntries(
      <String, dynamic>{
        "q": searchObject.contains,
        "format": "json",
        "countrycodes": "ba",
        "accept-language": "bs",
        "limit": _limit,
      }.entries,
    );
    if (_excludeIds.isNotEmpty) {
      queryParams.addEntries(
        <String, dynamic>{"exclude_place_ids": _excludeIds.join(",")}.entries,
      );
    }
    return queryParams;
  }

  void _convertResponse(dynamic response) {
    final listItems = List<NominatimResponse>.from(
      response.data.map((i) => parseJson<NominatimResponse>(i)).toList(),
    );
    final result = SearchResult<NominatimResponse>(
      items: listItems,
      hasMore: listItems.length == _limit,
    );
    _fillUpExcludingIds(listItems);
    result.copyTo(searchResult);
  }

  void _fillUpExcludingIds(List<NominatimResponse> response) {
    _excludeIds.addAll(response.map((i) => i.placeId).toList());
  }
}
