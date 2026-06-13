import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_location_dto.g.dart';

@JsonSerializable()
class FareLocationDto extends JsonRequest {
  final int userId;
  final String lat;
  final String lon;
  final DateTime dateTime;

  FareLocationDto({
    required this.userId,
    required this.lat,
    required this.lon,
    required this.dateTime,
  });

  @override
  Map<String, dynamic> toJson() => _$FareLocationDtoToJson(this);
  factory FareLocationDto.fromJson(Map<String, dynamic> json) =>
      _$FareLocationDtoFromJson(json);
}
