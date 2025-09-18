import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';

abstract class ErrorHandler {
  static void handle(Object ex, StackTrace stack) {
    _logToConsole(ex, stack);
    _showSnackBar(_getMessageFromException(ex));
  }

  static void _logToConsole(Object ex, StackTrace stack) {
    if (ex is DioException) {
      log("RESPONSE => ${ex.response}", time: DateTime.now(), level: 1000);
    }
    log("ERROR => $ex", time: DateTime.now(), stackTrace: stack, level: 1000);
  }

  static void _showSnackBar(String message) {
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }

  static String _getMessageFromException(Object e) {
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
