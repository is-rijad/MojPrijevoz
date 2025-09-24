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
      fuelConsumption: (json['fuelConsumption'] as num).toDouble(),
      pricePerKm: (json['pricePerKm'] as num).toDouble(),
      picture: json['picture'] as String?,
      status: $enumDecode(_$UserVehicleStatusEnumMap, json['status']),
      vehicle: VehicleResponse.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserVehicleResponseToJson(
  UserVehicleResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'modelYear': instance.modelYear,
  'fuelConsumption': instance.fuelConsumption,
  'pricePerKm': instance.pricePerKm,
  'picture': instance.picture,
  'status': _$UserVehicleStatusEnumMap[instance.status]!,
  'vehicle': instance.vehicle,
};

const _$UserVehicleStatusEnumMap = {
  UserVehicleStatus.deleted: 0,
  UserVehicleStatus.active: 1,
  UserVehicleStatus.waitingForChanges: 2,
  UserVehicleStatus.waitingForReview: 3,
};
