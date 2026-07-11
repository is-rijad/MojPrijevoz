// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_by_city_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersByCityResponse _$UsersByCityResponseFromJson(Map<String, dynamic> json) =>
    UsersByCityResponse(
      cityName: json['cityName'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String,
      usersCount: (json['usersCount'] as num).toInt(),
    );

Map<String, dynamic> _$UsersByCityResponseToJson(
  UsersByCityResponse instance,
) => <String, dynamic>{
  'cityName': instance.cityName,
  'lat': instance.lat,
  'long': instance.long,
  'usersCount': instance.usersCount,
};
