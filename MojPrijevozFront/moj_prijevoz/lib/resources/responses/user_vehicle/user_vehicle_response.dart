import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
part 'user_vehicle_response.g.dart';

@JsonSerializable()
class UserVehicleResponse extends JsonResponse {
  @override
  final int id;
  final int vehicleId;
  final int profileId;
  final int modelYear;
  final double fuelConsumption;
  final double pricePerKm;
  final String? picture;
  final UserVehicleStatus status;
  final VehicleResponse vehicle;

  UserVehicleResponse({
    required this.id,
    required this.vehicleId,
    required this.modelYear,
    required this.fuelConsumption,
    required this.pricePerKm,
    this.picture,
    required this.status,
    required this.vehicle,
    required this.profileId,
  });

  @override
  Map<String, dynamic> toJson() => _$UserVehicleResponseToJson(this);

  factory UserVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleResponseFromJson(json);
}
