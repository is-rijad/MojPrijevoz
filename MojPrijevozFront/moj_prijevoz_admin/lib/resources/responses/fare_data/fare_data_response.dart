import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'fare_data_response.g.dart';

@JsonSerializable()
class FareDataResponse extends JsonResponse {
  @override
  final int id;
  final String destinationName;
  final CityResponse? originCity;
  String get trimmedDestinationName => destinationName.split(",")[0];
  FareDataResponse({
    required this.id,
    required this.destinationName,
    this.originCity,
  });

  factory FareDataResponse.fromJson(Map<String, dynamic> json) =>
      _$FareDataResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FareDataResponseToJson(this);
}
