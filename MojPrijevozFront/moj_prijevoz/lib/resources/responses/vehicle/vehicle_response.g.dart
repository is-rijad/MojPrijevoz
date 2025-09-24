// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleResponse _$VehicleResponseFromJson(Map<String, dynamic> json) =>
    VehicleResponse(
      id: (json['id'] as num).toInt(),
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      numberOfSeats: (json['numberOfSeats'] as num).toInt(),
    );

Map<String, dynamic> _$VehicleResponseToJson(VehicleResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'numberOfSeats': instance.numberOfSeats,
    };
