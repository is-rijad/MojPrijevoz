// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'vehicle_upsert_request.g.dart';

@JsonSerializable()
class VehicleUpsertRequest extends JsonRequest {
  String? manufacturer;
  String? model;
  VehicleUpsertRequest({this.model, this.manufacturer});

  factory VehicleUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$VehicleUpsertRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VehicleUpsertRequestToJson(this);
}
