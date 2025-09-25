import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import "package:moj_prijevoz/providers/ui_provider.dart";
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
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

  Future<TResponse> getSingle<TResponse>(
    String url, {
    int? id,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading(loadingType);
      var path = "$_apiUrl$url";
      if (id != null) path += "/$id";
      var options = await _setRequestOptions();
      var response = await _dio.get(
        path,
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<SearchResult<TResponse>> getAll<
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
        hasMore: response.data["hasMore"],
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

  Future<TResponse> put<TRequest extends JsonParsable, TResponse>(
    String url,
    int id,
    TRequest request, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading(loadingType);

      var options = await _setRequestOptions();
      var response = await _dio.put(
        "$_apiUrl$url/$id",
        data: request.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<void> delete(
    String url,
    int id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading(loadingType);

      var options = await _setRequestOptions();
      await _dio.delete(
        "$_apiUrl$url/$id",
        options: options,
        queryParameters: queryParameters,
      );
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
    } on Exception {}

    options.headers = headersMap;
    return options;
  }
}
