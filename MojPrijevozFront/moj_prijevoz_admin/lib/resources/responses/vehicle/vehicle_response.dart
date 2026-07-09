import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/all_vehicles_response.dart';

part 'vehicle_response.g.dart';

@JsonSerializable()
class VehicleResponse extends AllVehiclesResponse {
  @override
  String toString() {
    return "$model $manufacturer";
  }

  VehicleResponse({
    required super.id,
    required super.manufacturer,
    required super.model,
    required super.createdAt,
    required super.updatedAt,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VehicleResponseToJson(this);
}
