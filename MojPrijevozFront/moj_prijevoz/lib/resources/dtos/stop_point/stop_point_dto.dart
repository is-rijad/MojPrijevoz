import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'stop_point_dto.g.dart';

@JsonSerializable()
class StopPointDto extends JsonRequest {
  final String lat;
  final String long;
  final String name;

  StopPointDto({required this.lat, required this.long, required this.name});

  @override
  Map<String, dynamic> toJson() => _$StopPointDtoToJson(this);
  factory StopPointDto.fromJson(Map<String, dynamic> json) =>
      _$StopPointDtoFromJson(json);
}
