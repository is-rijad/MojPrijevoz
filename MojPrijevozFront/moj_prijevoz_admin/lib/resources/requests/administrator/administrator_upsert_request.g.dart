// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrator_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdministratorUpsertRequest _$AdministratorUpsertRequestFromJson(
  Map<String, dynamic> json,
) => AdministratorUpsertRequest(
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  username: json['username'] as String?,
  status: $enumDecodeNullable(_$AccountStatusEnumMap, json['status']),
  role: $enumDecodeNullable(_$AdministartorRoleEnumMap, json['role']),
  changePassword: json['changePassword'] as bool?,
);

Map<String, dynamic> _$AdministratorUpsertRequestToJson(
  AdministratorUpsertRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'username': instance.username,
  'status': _$AccountStatusEnumMap[instance.status],
  'role': _$AdministartorRoleEnumMap[instance.role],
  'changePassword': instance.changePassword,
};

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};

const _$AdministartorRoleEnumMap = {
  AdministartorRole.moderator: 0,
  AdministartorRole.admin: 1,
};
