import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_profile/user_profile_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_user_vehicles_response.g.dart';

@JsonSerializable()
class AllUserVehiclesResponse extends JsonResponse {
  @override
  final int id;
  final int vehicleId;
  final int profileId;

  final int modelYear;

  final String licensePlate;

  final double pricePerKm;

  UserVehicleStatus status;
  final VehicleResponse? vehicle;
  final UserProfileResponse? profile;

  AllUserVehiclesResponse({
    required this.id,
    required this.vehicleId,
    required this.modelYear,
    required this.licensePlate,
    required this.pricePerKm,
    required this.status,
    this.vehicle,
    required this.profileId,
    this.profile,
  });

  factory AllUserVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$AllUserVehiclesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllUserVehiclesResponseToJson(this);
}
