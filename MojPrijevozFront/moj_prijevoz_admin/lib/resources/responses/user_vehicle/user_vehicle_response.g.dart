// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleResponse _$UserVehicleResponseFromJson(Map<String, dynamic> json) =>
    UserVehicleResponse(
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
          : UserProfileResponse.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
    )..picture = json['picture'] as String?;

Map<String, dynamic> _$UserVehicleResponseToJson(
  UserVehicleResponse instance,
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
  'picture': instance.picture,
};

const _$UserVehicleStatusEnumMap = {
  UserVehicleStatus.deleted: 0,
  UserVehicleStatus.active: 1,
  UserVehicleStatus.waitingForChanges: 2,
  UserVehicleStatus.waitingForReview: 3,
};
