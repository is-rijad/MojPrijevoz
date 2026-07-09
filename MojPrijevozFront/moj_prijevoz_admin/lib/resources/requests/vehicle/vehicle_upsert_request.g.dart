// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleUpsertRequest _$VehicleUpsertRequestFromJson(
  Map<String, dynamic> json,
) => VehicleUpsertRequest(
  model: json['model'] as String?,
  manufacturer: json['manufacturer'] as String?,
);

Map<String, dynamic> _$VehicleUpsertRequestToJson(
  VehicleUpsertRequest instance,
) => <String, dynamic>{
  'manufacturer': instance.manufacturer,
  'model': instance.model,
};
