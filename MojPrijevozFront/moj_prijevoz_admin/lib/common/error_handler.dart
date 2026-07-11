import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/user_exception.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';

abstract class ErrorHandler {
  static String? handle(Object ex, StackTrace stack, {showSnackBar = false}) {
    _logToConsole(ex, stack);
    var message = _getMessageFromException(ex);
    if (showSnackBar && message != null) {
      _showSnackBar(message);
    }
    return message;
  }

  static void _logToConsole(Object ex, StackTrace stack) {
    if (ex is DioException) {
      log("RESPONSE => ${ex.response}", time: DateTime.now(), level: 1000);
      log(
        "STATUS CODE => ${ex.response?.statusCode}",
        time: DateTime.now(),
        level: 1000,
      );
      log(
        "MESSAGE => ${ex.response?.statusMessage}",
        time: DateTime.now(),
        level: 1000,
      );
    }
    log("ERROR => $ex", time: DateTime.now(), stackTrace: stack, level: 1000);
  }

  static void _showSnackBar(String message) {
    Constants.messengerKey.currentState?.showSnackBar(
      ErrorSnackBar(message: message),
    );
  }

  static String? _getMessageFromException(Object e) {
    String? message = "Neočekivana greška!";
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.cancel:
          message = null;
          break;
        case DioExceptionType.sendTimeout:
          message = 'Nema odgovora od servera. Provjerite konekciju.';
          break;
        case DioExceptionType.connectionError:
          message = 'Nema internet konekcije.';
          break;
        case DioExceptionType.connectionTimeout:
          message = 'Nema odgovora od servera. Provjerite konekciju.';

          break;
        case DioExceptionType.receiveTimeout:
          message = 'Nema odgovora od servera. Provjerite konekciju.';

          break;
        case DioExceptionType.badCertificate:
          break;
        case DioExceptionType.badResponse:
          if (e.response!.statusCode != null) {
            switch (e.response!.statusCode!) {
              case 401:
                message = null;
                break;
            }
          }
          if (e.response!.data != null &&
              e.response!.data is Map<String, dynamic> &&
              e.response!.data["message"] != null) {
            message = e.response!.data["message"];
          }
          break;
        case DioExceptionType.unknown:
          break;
      }
    } else if (e is UserException && e.message != null) {
      message = e.message!;
    }
    return message;
  }
}
