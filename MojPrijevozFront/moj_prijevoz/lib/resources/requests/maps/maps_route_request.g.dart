// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maps_route_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapsRouteRequest _$MapsRouteRequestFromJson(Map<String, dynamic> json) =>
    MapsRouteRequest(
      units: json['units'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      radiuses: (json['radiuses'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$MapsRouteRequestToJson(MapsRouteRequest instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'radiuses': instance.radiuses,
      'units': instance.units,
    };
