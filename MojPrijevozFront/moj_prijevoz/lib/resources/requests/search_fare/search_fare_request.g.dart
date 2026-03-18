// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fare_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFareRequest _$SearchFareRequestFromJson(Map<String, dynamic> json) =>
    SearchFareRequest(
        startLocation: json['startLocation'] == null
            ? null
            : CityResponse.fromJson(
                json['startLocation'] as Map<String, dynamic>,
              ),
        stopPlaces: (json['stopPlaces'] as List<dynamic>?)
            ?.map((e) => NominatimResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
        finalLocation: json['finalLocation'] == null
            ? null
            : NominatimResponse.fromJson(
                json['finalLocation'] as Map<String, dynamic>,
              ),
        fareDateTime: json['fareDateTime'] == null
            ? null
            : DateTime.parse(json['fareDateTime'] as String),
        budget: (json['budget'] as num?)?.toDouble(),
      )
      ..isValid = json['isValid'] as bool
      ..isChanged = json['isChanged'] as bool;

Map<String, dynamic> _$SearchFareRequestToJson(SearchFareRequest instance) =>
    <String, dynamic>{
      'startLocation': instance.startLocation,
      'stopPlaces': instance.stopPlaces,
      'finalLocation': instance.finalLocation,
      'fareDateTime': instance.fareDateTime?.toIso8601String(),
      'budget': instance.budget,
      'isValid': instance.isValid,
      'isChanged': instance.isChanged,
    };
