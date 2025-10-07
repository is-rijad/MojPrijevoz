import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
part 'maps_route_request.g.dart';

@JsonSerializable()
class MapsRouteRequest extends JsonRequest {
  final List<List<String>> coordinates;
  final List<double> radiuses;
  final String units;

  MapsRouteRequest({
    required this.units,
    required this.coordinates,
    required this.radiuses,
  });

  @override
  Map<String, dynamic> toJson() => _$MapsRouteRequestToJson(this);

  factory MapsRouteRequest.fromJson(Map<String, dynamic> json) =>
      _$MapsRouteRequestFromJson(json);
}
