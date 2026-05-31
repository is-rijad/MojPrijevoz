// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      numberOfFares: (json['numberOfFares'] as num).toInt(),
      profileType: $enumDecode(_$ProfileTypeEnumMap, json['profileType']),
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      averageReview: (json['averageReview'] as num).toDouble(),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
  UserProfileResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'numberOfFares': instance.numberOfFares,
  'profileType': _$ProfileTypeEnumMap[instance.profileType]!,
  'averageReview': instance.averageReview,
  'user': instance.user,
};

const _$ProfileTypeEnumMap = {ProfileType.passenger: 0, ProfileType.driver: 1};
