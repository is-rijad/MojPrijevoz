// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponse _$RatingResponseFromJson(Map<String, dynamic> json) =>
    RatingResponse(
      comment: json['comment'] as String?,
      fareId: (json['fareId'] as num).toInt(),
      fare: json['fare'] == null
          ? null
          : FareResponse.fromJson(json['fare'] as Map<String, dynamic>),
      id: (json['id'] as num).toInt(),
      fromId: (json['fromId'] as num).toInt(),
      toId: (json['toId'] as num).toInt(),
      grade: (json['grade'] as num).toInt(),
      isVisible: json['isVisible'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      from: json['from'] == null
          ? null
          : UserProfileResponse.fromJson(json['from'] as Map<String, dynamic>),
      to: json['to'] == null
          ? null
          : UserProfileResponse.fromJson(json['to'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingResponseToJson(RatingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'from': instance.from,
      'to': instance.to,
      'grade': instance.grade,
      'isVisible': instance.isVisible,
      'createdAt': instance.createdAt.toIso8601String(),
      'comment': instance.comment,
      'fareId': instance.fareId,
      'fare': instance.fare,
    };
