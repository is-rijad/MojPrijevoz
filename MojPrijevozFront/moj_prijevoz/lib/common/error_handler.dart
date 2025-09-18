import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';

abstract class ErrorHandler {
  static void handle(Object ex, StackTrace stack) {
    Exception exception = ex as Exception;
    _logToConsole(ex, stack);
    _showSnackBar(_getMessageFromException(exception));
  }

  static void _logToConsole(Exception ex, StackTrace stack) {
    log("ERROR => $ex", time: DateTime.now(), stackTrace: stack, level: 1000);
  }

  static void _showSnackBar(String message) {
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }

  static String _getMessageFromException(Exception e) {
    String message = "Something went wrong!";

    if (e is DioException &&
        e.response != null &&
        e.response!.data != null &&
        e.response!.data["message"] != null) {
      message = e.response!.data["message"];
    }
    return message;
  }
}
