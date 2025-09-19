import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends JsonParsable
    implements UserForCircleAvatarInterface {
  @override
  String firstName;
  @override
  String lastName;
  String email;
  String username;
  @override
  String? picture;
  AuthResponse({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.picture,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
