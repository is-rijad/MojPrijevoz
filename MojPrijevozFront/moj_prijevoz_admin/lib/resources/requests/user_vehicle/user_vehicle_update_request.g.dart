// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleUpdateRequest _$UserVehicleUpdateRequestFromJson(
  Map<String, dynamic> json,
) => UserVehicleUpdateRequest(
  status: $enumDecodeNullable(_$UserVehicleStatusEnumMap, json['status']),
);

Map<String, dynamic> _$UserVehicleUpdateRequestToJson(
  UserVehicleUpdateRequest instance,
) => <String, dynamic>{'status': _$UserVehicleStatusEnumMap[instance.status]};

const _$UserVehicleStatusEnumMap = {
  UserVehicleStatus.deleted: 0,
  UserVehicleStatus.active: 1,
  UserVehicleStatus.waitingForChanges: 2,
  UserVehicleStatus.waitingForReview: 3,
};
