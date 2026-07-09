// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSearchObject _$RatingSearchObjectFromJson(Map<String, dynamic> json) =>
    RatingSearchObject(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      contains: json['contains'] as String?,
      orderBy: json['orderBy'] as String?,
      orderDirection: json['orderDirection'] as String?,
    );

Map<String, dynamic> _$RatingSearchObjectToJson(RatingSearchObject instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'orderDirection': instance.orderDirection,
      'contains': instance.contains,
    };
