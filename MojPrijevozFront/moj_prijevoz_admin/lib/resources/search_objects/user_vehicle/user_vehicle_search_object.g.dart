// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleSearchObject _$UserVehicleSearchObjectFromJson(
  Map<String, dynamic> json,
) => UserVehicleSearchObject(
  contains: json['contains'] as String?,
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  orderBy: json['orderBy'] as String?,
  orderDirection: json['orderDirection'] as String?,
);

Map<String, dynamic> _$UserVehicleSearchObjectToJson(
  UserVehicleSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'orderBy': instance.orderBy,
  'orderDirection': instance.orderDirection,
  'contains': instance.contains,
};
