import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/dio_client.dart';
import 'package:moj_prijevoz_admin/common/env.dart';
import 'package:moj_prijevoz_admin/common/providers/auth_provider.dart';
import "package:moj_prijevoz_admin/common/providers/ui_provider.dart";
import 'package:moj_prijevoz_admin/common/resources/search_objects/base_search_object.dart';
import 'package:moj_prijevoz_admin/common/resources/search_result.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class HttpProvider {
  final String _apiUrl = Environment.apiUrl;
  final UIProvider _uiProvider = GetIt.I<UIProvider>();

  Future<TResponse> getSingle<TResponse>(
    String url, {
    int? id,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading();
      var path = "$_apiUrl$url";
      if (id != null) path += "/$id";
      var options = await _setRequestOptions();
      var response = await DioClient.dio.get(
        path,
        options: options,
        queryParameters: queryParameters,
      );
      if (response.data is Map<String, dynamic>) {
        return parseJson<TResponse>(response.data);
      }
      return response.data as TResponse;
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<dynamic> downloadFile(
    String url,
    String filePath, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading();
      var path = "$_apiUrl$url";
      var options = await _setRequestOptions();
      options.contentType = "application/pdf";
      options.responseType = ResponseType.bytes;

      await DioClient.dio.download(
        path,
        filePath,
        options: options,
        queryParameters: queryParameters,
      );
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<SearchResult<TResponse>> getAll<
    TResponse,
    TSearchObject extends BaseSearchObject
  >(String url, TSearchObject search, {Map<String, dynamic>? query}) async {
    try {
      _uiProvider.startLoading();

      var queryParameters = search.toJson();
      if (query != null) {
        queryParameters.addEntries(query.entries);
      }
      var options = await _setRequestOptions();
      var response = await DioClient.dio.get(
        "$_apiUrl$url",
        options: options,
        queryParameters: queryParameters,
      );
      return SearchResult<TResponse>(
        items: List<TResponse>.from(
          response.data["items"].map((it) => parseJson<TResponse>(it)),
        ),
        hasMore: response.data["hasMore"],
      );
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<SearchResult<TResponse>> getAllWithoutSearchObject<TResponse>(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      _uiProvider.startLoading();

      var options = await _setRequestOptions();
      var response = await DioClient.dio.get(
        "$_apiUrl$url",
        options: options,
        queryParameters: query,
      );
      return SearchResult<TResponse>(
        items: List<TResponse>.from(
          response.data["items"].map((it) => parseJson<TResponse>(it)),
        ),
        hasMore: response.data["hasMore"],
      );
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<TResponse> post<TRequest extends JsonParsable, TResponse>(
    String url,
    TRequest? request, {
    Map<String, dynamic>? queryParameters,
    FormData? formData,
  }) async {
    try {
      assert(formData == null || request == null);

      _uiProvider.startLoading();

      var options = await _setRequestOptions();

      if (formData != null) {
        options = options.copyWith(contentType: 'multipart/form-data');
      }

      var response = await DioClient.dio.post(
        "$_apiUrl$url",
        data: formData ?? request?.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      if (response.data != "") {
        return parseJson<TResponse>(response.data);
      }
      return response.data;
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<TResponse?> put<TRequest extends JsonParsable, TResponse>(
    String url,
    int? id,
    TRequest? request, {
    Map<String, dynamic>? queryParameters,
    FormData? formData,
  }) async {
    try {
      _uiProvider.startLoading();

      var options = await _setRequestOptions();
      if (formData != null) {
        options = options.copyWith(contentType: 'multipart/form-data');
      }
      var apiUrl = "$_apiUrl$url/";
      if (id != null) {
        apiUrl += id.toString();
      }
      var response = await DioClient.dio.put(
        apiUrl,
        data: formData ?? request?.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      if (response.data != "") {
        return parseJson<TResponse>(response.data);
      }
      return null;
    } finally {
      _uiProvider.stopLoading();
    }
  }

  Future<void> delete(
    String url,
    int? id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _uiProvider.startLoading();

      var options = await _setRequestOptions();
      var requestUrl = url.endsWith("/") ? "$_apiUrl$url" : "$_apiUrl$url/";
      if (id != null) {
        requestUrl += id.toString();
      }
      await DioClient.dio.delete(
        requestUrl,
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
      var token = await AuthProvider.getAccessToken();
      headersMap.addEntries(
        <String, dynamic>{"Authorization": "Bearer $token"}.entries,
      );
    } catch (_) {}

    options.headers = headersMap;
    return options;
  }
}
