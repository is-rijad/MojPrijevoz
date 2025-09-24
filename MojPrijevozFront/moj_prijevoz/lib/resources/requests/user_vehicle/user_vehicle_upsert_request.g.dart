// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleUpsertRequest _$UserVehicleUpsertRequestFromJson(
  Map<String, dynamic> json,
) => UserVehicleUpsertRequest(
  id: (json['id'] as num?)?.toInt(),
  vehicleId: (json['vehicleId'] as num?)?.toInt(),
  modelYear: (json['modelYear'] as num?)?.toInt(),
  fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble(),
  pricePerKm: (json['pricePerKm'] as num?)?.toDouble(),
  picture: json['picture'] as String?,
);

Map<String, dynamic> _$UserVehicleUpsertRequestToJson(
  UserVehicleUpsertRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'modelYear': instance.modelYear,
  'fuelConsumption': instance.fuelConsumption,
  'pricePerKm': instance.pricePerKm,
  'picture': instance.picture,
};
