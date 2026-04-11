// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/utils/json_parser.dart';

part 'stop_point_response.g.dart';

@JsonSerializable()
class StopPointResponse extends JsonResponse {
  @override
  final int id;
  final int order;
  final String lat;
  final String long;
  final String name;
  String get trimmedName => name.split(",")[0];
  StopPointResponse({
    required this.id,
    required this.order,
    required this.lat,
    required this.long,
    required this.name,
  });

  @override
  Map<String, dynamic> toJson() => _$StopPointResponseToJson(this);

  factory StopPointResponse.fromJson(Map<String, dynamic> json) =>
      _$StopPointResponseFromJson(json);
}
