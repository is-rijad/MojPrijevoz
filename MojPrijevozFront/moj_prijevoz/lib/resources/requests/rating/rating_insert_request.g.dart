// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingInsertRequest _$RatingInsertRequestFromJson(Map<String, dynamic> json) =>
    RatingInsertRequest(
      fareId: (json['fareId'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      grade: (json['grade'] as num?)?.toInt(),
      profileType: $enumDecodeNullable(
        _$ProfileTypeEnumMap,
        json['profileType'],
      ),
    );

Map<String, dynamic> _$RatingInsertRequestToJson(
  RatingInsertRequest instance,
) => <String, dynamic>{
  'fareId': instance.fareId,
  'comment': instance.comment,
  'grade': instance.grade,
  'profileType': _$ProfileTypeEnumMap[instance.profileType],
};

const _$ProfileTypeEnumMap = {ProfileType.passenger: 0, ProfileType.driver: 1};
