import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'drivers_discount_response.g.dart';

@JsonSerializable()
class DriversDiscountResponse extends JsonResponse {
  @override
  final int id;
  final double minKm;
  final double? maxKm;
  final double discount;

  DriversDiscountResponse({
    required this.id,
    required this.minKm,
    this.maxKm,
    required this.discount,
  });

  @override
  String toString() {
    return "${minKm}km - ${maxKm ?? "Neograničeno "}km";
  }

  @override
  Map<String, dynamic> toJson() => _$DriversDiscountResponseToJson(this);

  factory DriversDiscountResponse.fromJson(Map<String, dynamic> json) =>
      _$DriversDiscountResponseFromJson(json);
}
