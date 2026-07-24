// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  firstName: json['firstName'] as String,
  id: (json['id'] as num).toInt(),
  picture: json['picture'] as String?,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  phoneNumber: json['phoneNumber'] as String,
  registeredAt: DateTime.parse(json['registeredAt'] as String),
  bankAccountNumber: json['bankAccountNumber'] as String?,
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'phoneNumber': instance.phoneNumber,
      'bankAccountNumber': instance.bankAccountNumber,
      'registeredAt': instance.registeredAt.toIso8601String(),
      'picture': instance.picture,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};
