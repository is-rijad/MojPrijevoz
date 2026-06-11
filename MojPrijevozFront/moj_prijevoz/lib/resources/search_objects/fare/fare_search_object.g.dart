// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareSearchObject _$FareSearchObjectFromJson(Map<String, dynamic> json) =>
    FareSearchObject(
      fareRole: $enumDecode(_$ProfileTypeEnumMap, json['fareRole']),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      fareId: (json['fareId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FareSearchObjectToJson(FareSearchObject instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'fareRole': _$ProfileTypeEnumMap[instance.fareRole]!,
      'fareId': instance.fareId,
    };

const _$ProfileTypeEnumMap = {ProfileType.passenger: 0, ProfileType.driver: 1};
