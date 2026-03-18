// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/utils/json_parser.dart';

part 'search_fare_driver_response.g.dart';

@JsonSerializable()
class SearchFareDriverResponse extends JsonResponse {
  @override
  final int id;
  double price;
  double? additionalPrice;
  int userVehicleId;
  int vehicleId;
  SearchFareDriverResponse({
    required this.id,
    required this.price,
    this.additionalPrice,
    required this.vehicleId,
    required this.userVehicleId,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareDriverResponseToJson(this);

  factory SearchFareDriverResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchFareDriverResponseFromJson(json);
}
