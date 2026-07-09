// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_administrator_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllAdministratorResponse _$AllAdministratorResponseFromJson(
  Map<String, dynamic> json,
) => AllAdministratorResponse(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  role: $enumDecode(_$AdministartorRoleEnumMap, json['role']),
);

Map<String, dynamic> _$AllAdministratorResponseToJson(
  AllAdministratorResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'username': instance.username,
  'status': _$AccountStatusEnumMap[instance.status]!,
  'role': _$AdministartorRoleEnumMap[instance.role]!,
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
