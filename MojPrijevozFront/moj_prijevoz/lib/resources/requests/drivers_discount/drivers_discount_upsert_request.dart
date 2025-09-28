import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'drivers_discount_upsert_request.g.dart';

@JsonSerializable()
class DriversDiscountUpsertRequest extends JsonRequest {
  double? minKm;
  double? maxKm;
  double? discount;

  DriversDiscountUpsertRequest({this.minKm, this.maxKm, this.discount});

  @override
  Map<String, dynamic> toJson() => _$DriversDiscountUpsertRequestToJson(this);

  factory DriversDiscountUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$DriversDiscountUpsertRequestFromJson(json);
}
