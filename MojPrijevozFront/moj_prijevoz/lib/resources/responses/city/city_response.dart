import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'city_response.g.dart';

@JsonSerializable()
class CityResponse extends JsonParsable {
  int id;
  String name;
  String long;
  String lat;

  CityResponse({
    required this.id,
    required this.name,
    required this.long,
    required this.lat,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) =>
      _$CityResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CityResponseToJson(this);
}
