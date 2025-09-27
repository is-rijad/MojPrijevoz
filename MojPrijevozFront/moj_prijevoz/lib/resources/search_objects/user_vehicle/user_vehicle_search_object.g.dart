// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleSearchObject _$UserVehicleSearchObjectFromJson(
  Map<String, dynamic> json,
) => UserVehicleSearchObject(
  profileId: (json['profileId'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$UserVehicleSearchObjectToJson(
  UserVehicleSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'profileId': instance.profileId,
};
