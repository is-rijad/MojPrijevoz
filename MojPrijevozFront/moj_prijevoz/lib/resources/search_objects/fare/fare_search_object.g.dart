// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareSearchObject _$FareSearchObjectFromJson(Map<String, dynamic> json) =>
    FareSearchObject(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$FareSearchObjectToJson(FareSearchObject instance) =>
    <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};
