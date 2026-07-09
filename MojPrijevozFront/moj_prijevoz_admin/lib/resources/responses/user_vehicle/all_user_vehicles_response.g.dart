// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_user_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllUserVehiclesResponse _$AllUserVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => AllUserVehiclesResponse(
  id: (json['id'] as num).toInt(),
  vehicleId: (json['vehicleId'] as num).toInt(),
  modelYear: (json['modelYear'] as num).toInt(),
  licensePlate: json['licensePlate'] as String,
  pricePerKm: (json['pricePerKm'] as num).toDouble(),
  status: $enumDecode(_$UserVehicleStatusEnumMap, json['status']),
  vehicle: json['vehicle'] == null
      ? null
      : VehicleResponse.fromJson(json['vehicle'] as Map<String, dynamic>),
  profileId: (json['profileId'] as num).toInt(),
  profile: json['profile'] == null
      ? null
      : UserProfileResponse.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AllUserVehiclesResponseToJson(
  AllUserVehiclesResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'profileId': instance.profileId,
  'modelYear': instance.modelYear,
  'licensePlate': instance.licensePlate,
  'pricePerKm': instance.pricePerKm,
  'status': _$UserVehicleStatusEnumMap[instance.status]!,
  'vehicle': instance.vehicle,
  'profile': instance.profile,
};

const _$UserVehicleStatusEnumMap = {
  UserVehicleStatus.deleted: 0,
  UserVehicleStatus.active: 1,
  UserVehicleStatus.waitingForChanges: 2,
  UserVehicleStatus.waitingForReview: 3,
};
