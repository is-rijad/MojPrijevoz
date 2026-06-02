import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/request_reset_password_request.dart';
import 'package:moj_prijevoz/resources/requests/user/reset_password_request.dart';
import 'package:moj_prijevoz/resources/responses/user/request_reset_password_response.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/resources/requests/user/update_user_request.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';

class UserProvider
    extends
        BaseProvider<
          UserResponse,
          BaseSearchObject,
          CreateUserRequest,
          UpdateUserRequest
        > {
  UserProvider() : super(providerName: "user");

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
