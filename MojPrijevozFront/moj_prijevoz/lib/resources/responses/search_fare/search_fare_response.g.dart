// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFareResponse _$SearchFareResponseFromJson(Map<String, dynamic> json) =>
    SearchFareResponse(
      id: (json['id'] as num).toInt(),
      profileId: (json['profileId'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      picture: json['picture'] as String?,
      averageReview: (json['averageReview'] as num).toDouble(),
      numberOfReviews: (json['numberOfReviews'] as num).toInt(),
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => UserVehicleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchFareResponseToJson(SearchFareResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'picture': instance.picture,
      'averageReview': instance.averageReview,
      'numberOfReviews': instance.numberOfReviews,
      'vehicles': instance.vehicles,
    };
