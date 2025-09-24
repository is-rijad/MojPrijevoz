// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleSearchObject _$VehicleSearchObjectFromJson(Map<String, dynamic> json) =>
    VehicleSearchObject(
      contains: json['contains'] as String?,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$VehicleSearchObjectToJson(
  VehicleSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'contains': instance.contains,
};
