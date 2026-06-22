// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_drivers_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedDriversSearchObject _$RecommendedDriversSearchObjectFromJson(
  Map<String, dynamic> json,
) => RecommendedDriversSearchObject(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$RecommendedDriversSearchObjectToJson(
  RecommendedDriversSearchObject instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};
