import 'package:moj_prijevoz/resources/common/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

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
  int passengerProfileId;
  int? driverProfileId;

  AccessTokenPayload({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.passengerProfileId,
    required this.status,
    this.driverProfileId,
    this.picture,
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
        passengerProfileId: int.parse(json["passenger_profile_id"]),
        driverProfileId: json["driver_profile_id"] != null
            ? int.parse(json["driver_profile_id"])
            : null,
        status: AccountStatus.values
            .where((it) => it.index == int.parse(json["account_status"]))
            .first,
      );
}
