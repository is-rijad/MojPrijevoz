import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_offer_driver_price_dto.g.dart';

@JsonSerializable()
class FareOfferDriverPriceDto extends JsonRequest {
  final int driverId;
  final int userVehicleId;
  final double price;
  final double? additionalPrice;

  FareOfferDriverPriceDto({
    required this.userVehicleId,
    required this.driverId,
    required this.price,
    this.additionalPrice,
  });

  @override
  Map<String, dynamic> toJson() => _$FareOfferDriverPriceDtoToJson(this);
  factory FareOfferDriverPriceDto.fromJson(Map<String, dynamic> json) =>
      _$FareOfferDriverPriceDtoFromJson(json);
}
