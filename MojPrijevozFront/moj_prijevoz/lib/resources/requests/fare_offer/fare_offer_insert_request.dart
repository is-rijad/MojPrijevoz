import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/dtos/fare_offer/fare_offer_driver_price_dto.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/dtos/stop_point/stop_point_dto.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_offer_insert_request.g.dart';

@JsonSerializable(explicitToJson: true)
class FareOfferInsertRequest extends JsonRequest {
  final int originCityId;
  final NominatimCityDto destinationCity;
  final String destinationName;
  final double length;
  final double duration;
  final List<FareOfferDriverPriceDto> driversPrices;
  final List<StopPointDto>? stopPoints;
  final DateTime fareDateTime;

  FareOfferInsertRequest({
    required this.originCityId,
    required this.destinationCity,
    required this.length,
    required this.duration,
    required this.driversPrices,
    this.stopPoints,
    required this.fareDateTime,
    required this.destinationName,
  });

  @override
  Map<String, dynamic> toJson() => _$FareOfferInsertRequestToJson(this);

  factory FareOfferInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$FareOfferInsertRequestFromJson(json);
}
