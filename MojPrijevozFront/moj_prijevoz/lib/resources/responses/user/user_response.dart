import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_with_preview_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse extends JsonResponse
    implements UserForCircleAvatarWithPreviewInterface {
  @override
  final int id;
  @override
  String firstName;
  @override
  String lastName;
  String email;
  String username;
  int cityId;
  @override
  String? picture;
  @override
  AccountStatus status;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  File? imagePreview;

  String get fullName => "$firstName $lastName";
  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.cityId,
    required this.status,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
