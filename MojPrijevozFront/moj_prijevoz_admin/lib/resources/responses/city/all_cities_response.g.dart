// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_cities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCitiesResponse _$AllCitiesResponseFromJson(Map<String, dynamic> json) =>
    AllCitiesResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AllCitiesResponseToJson(AllCitiesResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'long': instance.long,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
