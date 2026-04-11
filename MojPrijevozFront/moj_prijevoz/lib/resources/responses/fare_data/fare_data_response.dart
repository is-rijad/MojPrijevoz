import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/fare_offer/fare_offer_response.dart';
import 'package:moj_prijevoz/resources/responses/stop_points/stop_point_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_data_response.g.dart';

@JsonSerializable()
class FareDataResponse extends JsonResponse {
  @override
  final int id;
  final int originCityId;
  final String destinationLat;
  final String destinationLong;
  final int length;
  final int duration;
  final DateTime fareDateTime;
  final DateTime createdAt;
  final String destinationName;
  final CityResponse? originCity;
  final List<StopPointResponse>? stopPoints;
  final List<FareOfferResponse>? fareOffers;
  String get trimmedDestinationName => destinationName.split(",")[0];
  FareDataResponse({
    required this.id,
    required this.originCityId,
    required this.destinationLat,
    required this.destinationLong,
    required this.length,
    required this.duration,
    required this.fareDateTime,
    required this.createdAt,
    required this.destinationName,
    this.stopPoints,
    this.originCity,
    this.fareOffers,
  });

  @override
  Map<String, dynamic> toJson() => _$FareDataResponseToJson(this);

  factory FareDataResponse.fromJson(Map<String, dynamic> json) =>
      _$FareDataResponseFromJson(json);
}
