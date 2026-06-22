import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/resources/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class AccessTokenPayload implements UserForCircleAvatarInterface, JsonParsable {
  @override
  String firstName;

  @override
  String lastName;

  @override
  String? picture;
  @override
  AccountStatus status;
  int id;
  int? passengerProfileId;
  int? driverProfileId;
  AdministartorRole? role;

  AccessTokenPayload({
    required this.firstName,
    required this.lastName,
    required this.id,
    this.passengerProfileId,
    required this.status,
    this.driverProfileId,
    this.picture,
    this.role,
  });

  @override
  Map<String, dynamic> toJson() => {
    "name": firstName,
    "family_name": lastName,
    "sub": id,
    "picture": picture,
    "passenger_profile_id": passengerProfileId,
    "driver_profile_id": driverProfileId,
  };

  factory AccessTokenPayload.fromJson(Map<String, dynamic> json) =>
      AccessTokenPayload(
        firstName: json["name"],
        lastName: json["family_name"],
        id: int.parse(json["sub"]),
        picture: json["picture"],
        passengerProfileId: json["passenger_profile_id"] != null
            ? int.parse(json["passenger_profile_id"])
            : null,
        driverProfileId: json["driver_profile_id"] != null
            ? int.parse(json["driver_profile_id"])
            : null,
        role: json["role"] != null
            ? AdministartorRole.values
                  .where((it) => it.index == int.parse(json["role"]))
                  .first
            : null,
        status: AccountStatus.values
            .where((it) => it.index == int.parse(json["account_status"]))
            .first,
      );
}
