// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitySearchObject _$CitySearchObjectFromJson(Map<String, dynamic> json) =>
    CitySearchObject(
      contains: json['contains'] as String?,
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$CitySearchObjectToJson(CitySearchObject instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'contains': instance.contains,
    };
