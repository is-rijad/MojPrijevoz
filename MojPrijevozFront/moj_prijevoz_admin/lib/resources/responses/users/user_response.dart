import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/resources/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz_admin/resources/responses/users/users_response.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse extends UsersResponse
    implements UserForCircleAvatarInterface {
  @override
  String? picture;
  @override
  String toString() {
    return "$firstName $lastName";
  }

  UserResponse({
    required super.firstName,
    required super.id,
    this.picture,
    required super.lastName,
    required super.email,
    required super.username,
    required super.status,
    required super.phoneNumber,
    required super.registeredAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  static Map<String, String> userFieldsMap = {
    'firstName': "Ime",
    'lastName': "Prezime",
    'email': "Email",
    'username': "Korisničko ime",
    'status': "Status",
    'phoneNumber': "Broj mobitela",
    'picture': "Slika profila",
  };
}
