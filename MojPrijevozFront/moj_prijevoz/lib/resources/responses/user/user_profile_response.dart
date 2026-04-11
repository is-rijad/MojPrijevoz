// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse extends JsonResponse {
  @override
  final int id;
  final int userId;
  final int numberOfFares;
  final ProfileType profileType;
  final UserResponse? user;

  UserProfileResponse({
    required this.id,
    required this.userId,
    required this.numberOfFares,
    required this.profileType,
    this.user,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}
