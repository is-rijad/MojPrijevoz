// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vehicle_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVehicleUpsertRequest _$UserVehicleUpsertRequestFromJson(
  Map<String, dynamic> json,
) => UserVehicleUpsertRequest(
  vehicleId: (json['vehicleId'] as num?)?.toInt(),
  modelYear: (json['modelYear'] as num?)?.toInt(),
  licensePlate: json['licensePlate'] as String?,
  pricePerKm: (json['pricePerKm'] as num?)?.toDouble(),
  picture: json['picture'] as String?,
);

Map<String, dynamic> _$UserVehicleUpsertRequestToJson(
  UserVehicleUpsertRequest instance,
) => <String, dynamic>{
  'vehicleId': instance.vehicleId,
  'modelYear': instance.modelYear,
  'licensePlate': instance.licensePlate,
  'pricePerKm': instance.pricePerKm,
  'picture': instance.picture,
};
