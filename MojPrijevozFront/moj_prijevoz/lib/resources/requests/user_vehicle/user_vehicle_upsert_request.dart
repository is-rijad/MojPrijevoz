import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'user_vehicle_upsert_request.g.dart';

@JsonSerializable()
class UserVehicleUpsertRequest extends JsonParsable {
  int? id;
  int? vehicleId;
  int? modelYear;
  double? fuelConsumption;
  double? pricePerKm;
  String? picture;

  UserVehicleUpsertRequest({
    this.id,
    this.vehicleId,
    this.modelYear,
    this.fuelConsumption,
    this.pricePerKm,
    this.picture,
  });

  @override
  Map<String, dynamic> toJson() => _$UserVehicleUpsertRequestToJson(this);

  factory UserVehicleUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleUpsertRequestFromJson(json);
}
