import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/requests/has_picture_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest extends JsonRequest implements HasPictureInterface {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phoneNumber;
  String? oldPassword;
  String? password;
  String? passwordAgain;
  int? cityId;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  MultipartFile? picture;

  UpdateUserRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.oldPassword,
    this.password,
    this.passwordAgain,
    this.cityId,
    this.phoneNumber,
  });

  @override
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  factory UpdateUserRequest.fromJson(json) => _$UpdateUserRequestFromJson(json);
}
