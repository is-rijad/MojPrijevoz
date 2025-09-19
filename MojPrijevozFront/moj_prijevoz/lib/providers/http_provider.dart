import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import "package:moj_prijevoz/providers/ui_provider.dart";
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class HttpProvider {
  final _dio = Dio();
  final String _apiUrl = Environment.apiUrl;
  late final UIProvider _uiProvider;
  final LoadingType loadingType;

  HttpProvider({required this.loadingType}) {
    _uiProvider = GetIt.I<UIProvider>();
  }

  Future<TResponse> getById<TResponse>(
    int id,
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading(loadingType);

      var options = await _setRequestOptions();
      var response = await _dio.get(
        "$_apiUrl$url/$id",
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<SearchResult<TResponse>> get<
    TResponse,
    TSearchObject extends BaseSearchObject
  >(String url, TSearchObject search, {Map<String, dynamic>? query}) async {
    try {
      _uiProvider.startLoading(loadingType);

      var queryParameters = search.toJson();
      if (query != null) {
        queryParameters.addEntries(query.entries);
      }
      var options = await _setRequestOptions();
      var response = await _dio.get(
        "$_apiUrl$url",
        options: options,
        queryParameters: queryParameters,
      );
      return SearchResult(
        items: List<TResponse>.from(
          response.data["items"].map((it) => parseJson<TResponse>(it)),
        ),
        count: response.data["count"],
      );
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<TResponse> post<TRequest extends JsonParsable, TResponse>(
    String url,
    TRequest request, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading(loadingType);

      var options = await _setRequestOptions();
      var response = await _dio.post(
        "$_apiUrl$url",
        data: request.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<Options> _setRequestOptions() async {
    var options = Options(contentType: "application/json");
    var headersMap = <String, dynamic>{};
    try {
      var token = await AccessTokenHandler.getAccessToken();
      headersMap.addEntries(
        <String, dynamic>{"Authorization": "Bearer $token"}.entries,
      );
    } on Exception catch (e) {}

    options.headers = headersMap;
    return options;
  }
}
