import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_response.g.dart';

@JsonSerializable()
class FareResponse extends JsonResponse {
  @override
  final int id;
  final int originCityId;
  final String destinationLat;
  final String destinationLong;
  final int length;
  final int duration;
  final FareStatus status;
  final int driverId;
  final int passengerId;
  final double price;
  final DateTime fareDateTime;
  final DateTime createdAt;
  FareResponse({
    required this.id,
    required this.originCityId,
    required this.destinationLat,
    required this.destinationLong,
    required this.length,
    required this.duration,
    required this.status,
    required this.driverId,
    required this.passengerId,
    required this.price,
    required this.fareDateTime,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => _$FareResponseToJson(this);

  factory FareResponse.fromJson(Map<String, dynamic> json) =>
      _$FareResponseFromJson(json);
}
