import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/utils/json_parser.dart';

part 'vehicle_response.g.dart';

@JsonSerializable()
class VehicleResponse extends JsonResponse {
  @override
  final int id;
  final String manufacturer;
  final String model;
  final int numberOfSeats;

  @override
  String toString() {
    return "${manufacturer} ${model}";
  }

  VehicleResponse({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.numberOfSeats,
  });

  @override
  Map<String, dynamic> toJson() => _$VehicleResponseToJson(this);

  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseFromJson(json);
}
