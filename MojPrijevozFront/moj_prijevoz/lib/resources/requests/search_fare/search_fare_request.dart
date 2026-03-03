import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'search_fare_request.g.dart';

@JsonSerializable()
class SearchFareRequest extends JsonRequest {
  CityResponse? startLocation;
  List<NominatimResponse>? stopPlaces;
  NominatimResponse? finalLocation;
  DateTime? fareDateTime;
  double? budget;
  bool isValid = false;
  SearchFareRequest({
    this.startLocation,
    this.stopPlaces,
    this.finalLocation,
    this.fareDateTime,
    this.budget,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareRequestToJson(this);

  factory SearchFareRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchFareRequestFromJson(json);
}
