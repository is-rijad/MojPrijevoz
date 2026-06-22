import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_upsert_request.g.dart';

@JsonSerializable()
class FareUpsertRequest extends JsonRequest {
  final int originCityId;
  final NominatimCityDto destinationCity;
  final int length;
  final int duration;
  final FareStatus status;
  final int driverId;
  final int passengerId;
  final DateTime fareDateTime;

  FareUpsertRequest({
    required this.originCityId,
    required this.destinationCity,
    required this.length,
    required this.duration,
    required this.status,
    required this.driverId,
    required this.passengerId,
    required this.fareDateTime,
  });

  @override
  Map<String, dynamic> toJson() => _$FareUpsertRequestToJson(this);

  factory FareUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$FareUpsertRequestFromJson(json);
}
