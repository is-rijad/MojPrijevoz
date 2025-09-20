import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class AccessTokenPayload implements UserForCircleAvatarInterface, JsonParsable {
  @override
  String firstName;

  @override
  String lastName;

  @override
  String? picture;
  int id;
  AccessTokenPayload({
    required this.firstName,
    required this.lastName,
    required this.id,
    this.picture,
  });

  @override
  Map<String, dynamic> toMap() => {
    "name": firstName,
    "family_name": lastName,
    "sub": id,
    "picture": picture,
  };

  factory AccessTokenPayload.fromMap(Map<String, dynamic> json) =>
      AccessTokenPayload(
        firstName: json["name"],
        lastName: json["family_name"],
        id: int.parse(json["sub"]),
        picture: json["picture"],
      );
}
