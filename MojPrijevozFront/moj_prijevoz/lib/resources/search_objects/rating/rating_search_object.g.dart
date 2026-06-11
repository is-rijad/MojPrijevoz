// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSearchObject _$RatingSearchObjectFromJson(Map<String, dynamic> json) =>
    RatingSearchObject(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      profileId: (json['profileId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RatingSearchObjectToJson(RatingSearchObject instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'profileId': instance.profileId,
    };
