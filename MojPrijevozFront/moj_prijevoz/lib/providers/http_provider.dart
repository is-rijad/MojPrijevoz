import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/loading_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class HttpProvider {
  final _dio = Dio();
  final String _apiUrl = Environment.apiUrl;
  late final AuthProvider _authProvider;
  late final LoadingProvider _loadingProvider;

  HttpProvider() {
    _authProvider = GetIt.I<AuthProvider>();
    _loadingProvider = GetIt.I<LoadingProvider>();
  }

  Future<TResponse?> getById<TResponse>(
    int id,
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeAuthHeader = true,
  }) async {
    try {
      _loadingProvider.startLoading();
      var options = await _setRequestOptions(includeAuthHeader);
      var response = await _dio.get(
        "$_apiUrl$url/$id",
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      _loadingProvider.stopLoading();
    }
  }

  Future<SearchResult<TResponse>?>
  get<TResponse, TSearchObject extends BaseSearchObject>(
    String url,
    TSearchObject search, {
    Map<String, dynamic>? query,
    bool includeAuthHeader = true,
  }) async {
    try {
      _loadingProvider.startLoading();
      var queryParameters = search.toJson();
      if (query != null) {
        queryParameters.addEntries(query.entries);
      }
      var options = await _setRequestOptions(includeAuthHeader);
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
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      _loadingProvider.stopLoading();
    }
  }

  Future<TResponse?> post<TRequest extends JsonParsable, TResponse>(
    String url,
    TRequest request, {
    Map<String, dynamic>? queryParameters,
    bool includeAuthHeader = true,
  }) async {
    try {
      _loadingProvider.startLoading();
      var options = await _setRequestOptions(includeAuthHeader);
      var response = await _dio.post(
        "$_apiUrl$url",
        data: request.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      _loadingProvider.stopLoading();
    }
  }

  void _onError(DioException e) {
    debugPrint("ERROR => ${e.message}");
    String message;
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data["message"] != null) {
      message = e.response!.data["message"];
    } else {
      message = "Something went wrong!";
    }
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }

  Future<Options> _setRequestOptions(bool includeAuthHeader) async {
    var options = Options(contentType: "application/json");
    var headersMap = <String, dynamic>{};
    if (includeAuthHeader) {
      var token = await _authProvider.getAccessToken();
      headersMap.addEntries(<String, dynamic>{"Authorization": token}.entries);
    }
    options.headers = headersMap;
    return options;
  }
}
