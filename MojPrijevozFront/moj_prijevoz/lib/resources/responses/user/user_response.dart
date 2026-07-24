import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/common/resources/user_for_circle_avatar_with_preview_interface.dart';
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
  String phoneNumber;
  int cityId;
  @override
  String? picture;
  @override
  AccountStatus status;
  String? bankAccountNumber;

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
    required this.phoneNumber,
    required this.cityId,
    required this.status,
    required this.bankAccountNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
