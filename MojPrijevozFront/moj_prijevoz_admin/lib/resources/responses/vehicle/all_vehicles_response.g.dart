// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllVehiclesResponse _$AllVehiclesResponseFromJson(Map<String, dynamic> json) =>
    AllVehiclesResponse(
      id: (json['id'] as num).toInt(),
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AllVehiclesResponseToJson(
  AllVehiclesResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'manufacturer': instance.manufacturer,
  'model': instance.model,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
