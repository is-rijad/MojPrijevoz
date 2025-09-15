import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/snackbars.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class HttpProvider {
  final _dio = Dio();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final String apiUrl = Environment.apiUrl;
  late final AuthProvider _authProvider;

  HttpProvider() {
    _authProvider = GetIt.I<AuthProvider>();
  }

  Future<TResponse?> get<TResponse, TSearchObject extends BaseSearchObject>(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeAuthHeader = true,
  }) async {
    try {
      _startLoading();
      var options = await setRequestOptions(includeAuthHeader);
      var response = await _dio.get(
        "$apiUrl$url",
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      _stopLoading();
    }
  }

  Future<TResponse?> post<TRequest extends JsonParsable, TResponse>(
    String url,
    TRequest request, {
    Map<String, dynamic>? queryParameters,
    bool includeAuthHeader = true,
  }) async {
    try {
      _startLoading();
      var options = await setRequestOptions(includeAuthHeader);
      var response = await _dio.post(
        "$apiUrl$url",
        data: request.toJson(),
        options: options,
        queryParameters: queryParameters,
      );
      return parseJson<TResponse>(response.data);
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      _stopLoading();
    }
  }

  void _onError(DioException e) {
    String message;
    if (e.response != null && e.response!.data != null) {
      message = e.response!.data["message"];
    } else {
      message = "Something went wrong!";
    }
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }

  void _startLoading() {
    isLoading.value = true;
  }

  void _stopLoading() {
    isLoading.value = false;
  }

  Future<Options> setRequestOptions(bool includeAuthHeader) async {
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
