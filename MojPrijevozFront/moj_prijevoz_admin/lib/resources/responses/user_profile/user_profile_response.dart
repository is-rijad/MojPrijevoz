import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse extends JsonResponse {
  @override
  final int id;
  final int userId;
  final UserResponse? user;
  UserProfileResponse({required this.id, required this.userId, this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}
