import 'package:moj_prijevoz/utils/json_parser.dart';

class NominatimResponse extends JsonParsable {
  final int placeId;
  final String osmType;
  final int osmId;
  final String lat;
  final String lon;
  final String name;
  final String displayName;

  NominatimResponse({
    required this.placeId,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.name,
    required this.displayName,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "place_id": placeId,
      "osm_type": osmType,
      "osm_id": osmId,
      "lat": lat,
      "lon": lon,
      "name": name,
      "display_name": displayName,
    };
  }

  factory NominatimResponse.fromJson(Map<String, dynamic> json) {
    return NominatimResponse(
      placeId: int.parse(json["place_id"].toString()),
      osmType: json["osm_type"],
      osmId: int.parse(json["osm_id"].toString()),
      lat: json["lat"],
      lon: json["lon"],
      name: json["name"],
      displayName: json["display_name"],
    );
  }
}
