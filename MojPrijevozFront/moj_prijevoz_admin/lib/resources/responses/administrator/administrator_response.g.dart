// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrator_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdministratorResponse _$AdministratorResponseFromJson(
  Map<String, dynamic> json,
) => AdministratorResponse(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: $enumDecode(_$AdministartorRoleEnumMap, json['role']),
  email: json['email'] as String,
  username: json['username'] as String,
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
);

Map<String, dynamic> _$AdministratorResponseToJson(
  AdministratorResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'username': instance.username,
  'status': _$AccountStatusEnumMap[instance.status]!,
  'role': _$AdministartorRoleEnumMap[instance.role]!,
};

const _$AdministartorRoleEnumMap = {
  AdministartorRole.moderator: 0,
  AdministartorRole.admin: 1,
};

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};
