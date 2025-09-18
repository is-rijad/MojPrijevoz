import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/gender.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse extends JsonParsable {
  String firstName;
  String lastName;
  String email;
  String username;
  int cityId;
  Gender? gender;

  UserResponse({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.cityId,
    this.gender,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
