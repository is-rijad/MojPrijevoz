import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/snackbars.dart';
import 'package:moj_prijevoz/resources/json_parser.dart';
import 'dart:convert';

import 'package:moj_prijevoz/resources/requests/login_request.dart';
import 'package:moj_prijevoz/resources/responses/login_response.dart';

class HttpService {
  final _dio = Dio();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<TResponse> get<TResponse>(String url) async {
    var response = await _dio.get<TResponse>("${Environment.apiUrl}$url");
    if (response.statusCode == 200 || response.data == null) {
      return response.data!;
    } else {
      throw Exception("Something went wrong!");
    }
  }

  Future<TResponse?> post<TRequest extends JsonParsable, TResponse>(
    String url,
    TRequest request,
  ) async {
    try {
      isLoading.value = true;
      var response = await _dio.post(
        "${Environment.apiUrl}$url",
        data: request.toJson(),
        options: Options(contentType: "application/json"),
      );
      print(response.data);
      return parseJson<TResponse>(response.data);
    } on DioException catch (e) {
      _onError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void _onError(DioException e) {
    String message;
    if (e.response != null && e.response!.data != null) {
      message = e.response!.data["message"];
    } else {
      print(e);
      message = "Something went wrong!";
    }
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }
}
