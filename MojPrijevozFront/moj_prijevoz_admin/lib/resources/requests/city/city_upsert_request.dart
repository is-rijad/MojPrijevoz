// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'city_upsert_request.g.dart';

@JsonSerializable()
class CityUpsertRequest extends JsonRequest {
  String? name;
  String? lat;
  String? long;
  CityUpsertRequest({this.name, this.lat, this.long});

  factory CityUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$CityUpsertRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CityUpsertRequestToJson(this);
}
