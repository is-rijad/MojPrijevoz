// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_point_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopPointResponse _$StopPointResponseFromJson(Map<String, dynamic> json) =>
    StopPointResponse(
      id: (json['id'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      lat: json['lat'] as String,
      long: json['long'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StopPointResponseToJson(StopPointResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'lat': instance.lat,
      'long': instance.long,
      'name': instance.name,
    };
