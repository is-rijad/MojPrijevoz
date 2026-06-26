// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersResponse _$UsersResponseFromJson(Map<String, dynamic> json) =>
    UsersResponse(
      firstName: json['firstName'] as String,
      id: (json['id'] as num).toInt(),
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      status: $enumDecode(_$AccountStatusEnumMap, json['status']),
      phoneNumber: json['phoneNumber'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );

Map<String, dynamic> _$UsersResponseToJson(UsersResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'phoneNumber': instance.phoneNumber,
      'registeredAt': instance.registeredAt.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};
