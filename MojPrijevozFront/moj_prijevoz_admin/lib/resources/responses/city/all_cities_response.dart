import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_cities_response.g.dart';

@JsonSerializable()
class AllCitiesResponse extends JsonResponse {
  @override
  final int id;
  String name;
  String lat;
  String long;
  final DateTime createdAt;
  final DateTime updatedAt;
  AllCitiesResponse({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllCitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$AllCitiesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllCitiesResponseToJson(this);
}
