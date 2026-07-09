// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_ratings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllRatingsResponse _$AllRatingsResponseFromJson(Map<String, dynamic> json) =>
    AllRatingsResponse(
      id: (json['id'] as num).toInt(),
      fromId: (json['fromId'] as num).toInt(),
      toId: (json['toId'] as num).toInt(),
      from: json['from'] == null
          ? null
          : UserProfileResponse.fromJson(json['from'] as Map<String, dynamic>),
      to: json['to'] == null
          ? null
          : UserProfileResponse.fromJson(json['to'] as Map<String, dynamic>),
      grade: (json['grade'] as num).toInt(),
      isVisible: json['isVisible'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AllRatingsResponseToJson(AllRatingsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'from': instance.from,
      'to': instance.to,
      'grade': instance.grade,
      'isVisible': instance.isVisible,
      'createdAt': instance.createdAt.toIso8601String(),
    };
