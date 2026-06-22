import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/providers/http_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/requests/user/request_reset_password_request.dart';
import 'package:moj_prijevoz_admin/common/resources/requests/user/reset_password_request.dart';
import 'package:moj_prijevoz_admin/common/resources/responses/user/request_reset_password_response.dart';

class UserProvider with ChangeNotifier {
  final providerName = "user";
  final httpProvider = GetIt.I<HttpProvider>();
  UserProvider();

  Future<RequestResetPasswordResponse> requestResetPassword(
    RequestResetPasswordRequest request,
  ) async {
    return await httpProvider
        .post<RequestResetPasswordRequest, RequestResetPasswordResponse>(
          "$providerName/reset-password/code",
          request,
        );
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    return await httpProvider.post<ResetPasswordRequest, void>(
      "$providerName/reset-password",
      request,
    );
  }
}
