import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_vehicles_response.g.dart';

@JsonSerializable()
class AllVehiclesResponse extends JsonResponse {
  @override
  final int id;
  String manufacturer;
  String model;
  final DateTime createdAt;
  final DateTime updatedAt;

  AllVehiclesResponse({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$AllVehiclesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllVehiclesResponseToJson(this);
}
