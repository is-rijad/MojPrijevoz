import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/all_cities_response.dart';

part 'city_response.g.dart';

@JsonSerializable()
class CityResponse extends AllCitiesResponse {
  CityResponse({
    required super.id,
    required super.name,
    required super.lat,
    required super.long,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) =>
      _$CityResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CityResponseToJson(this);
}
