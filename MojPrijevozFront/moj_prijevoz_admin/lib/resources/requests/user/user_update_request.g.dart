// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    UserUpdateRequest(
      status: $enumDecodeNullable(_$AccountStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UserUpdateRequestToJson(UserUpdateRequest instance) =>
    <String, dynamic>{'status': _$AccountStatusEnumMap[instance.status]};

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};
