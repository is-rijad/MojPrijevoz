import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_profile/user_profile_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/all_user_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';

part 'user_vehicle_response.g.dart';

@JsonSerializable()
class UserVehicleResponse extends AllUserVehiclesResponse {
  String? picture;

  UserVehicleResponse({
    required super.id,
    required super.vehicleId,
    required super.modelYear,
    required super.licensePlate,
    required super.pricePerKm,
    required super.status,
    super.vehicle,
    required super.profileId,
    super.profile,
  });

  @override
  String toString() {
    return "${vehicle!.manufacturer} ${vehicle!.model} (${profile!.user!.toString()})";
  }

  factory UserVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserVehicleResponseToJson(this);

  static Map<String, String> userVehicleFieldsMap = {
    'modelYear': "Godina proizvodnje",
    'pricePerKm': "Cijena po kilometru",
    'picture': "Slika",
  };
}
