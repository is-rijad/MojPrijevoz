import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'nominatim_city_dto.g.dart';

@JsonSerializable()
class NominatimCityDto extends JsonRequest {
  final String long;
  final String lat;

  NominatimCityDto({required this.long, required this.lat});

  @override
  Map<String, dynamic> toJson() => _$NominatimCityDtoToJson(this);
  factory NominatimCityDto.fromJson(Map<String, dynamic> json) =>
      _$NominatimCityDtoFromJson(json);
  factory NominatimCityDto.fromNominatimResponse(NominatimResponse response) =>
      NominatimCityDto(long: response.lon, lat: response.lat);
}
