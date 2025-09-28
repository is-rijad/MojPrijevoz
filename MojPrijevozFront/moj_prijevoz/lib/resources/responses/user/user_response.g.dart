// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  cityId: (json['cityId'] as num).toInt(),
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
)..picture = json['picture'] as String?;

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'cityId': instance.cityId,
      'gender': _$GenderEnumMap[instance.gender],
      'picture': instance.picture,
    };

const _$GenderEnumMap = {Gender.female: 0, Gender.male: 1};
