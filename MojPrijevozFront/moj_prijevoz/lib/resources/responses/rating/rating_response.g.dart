// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponse _$RatingResponseFromJson(Map<String, dynamic> json) =>
    RatingResponse(
      fareId: (json['fareId'] as num).toInt(),
      comment: json['comment'] as String?,
      grade: (json['grade'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      fromId: (json['fromId'] as num).toInt(),
      from: UserProfileResponse.fromJson(json['from'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingResponseToJson(RatingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fareId': instance.fareId,
      'comment': instance.comment,
      'grade': instance.grade,
      'fromId': instance.fromId,
      'from': instance.from,
    };
