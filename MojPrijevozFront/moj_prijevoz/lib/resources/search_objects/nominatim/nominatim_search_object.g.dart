// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nominatim_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NominatimSearchObject _$NominatimSearchObjectFromJson(
  Map<String, dynamic> json,
) => NominatimSearchObject(
  contains: json['contains'] as String?,
  selectedPlaceId: (json['selectedPlaceId'] as num?)?.toInt(),
  selectedPlaceType: json['selectedPlaceType'] as String?,
)..page = (json['page'] as num).toInt();

Map<String, dynamic> _$NominatimSearchObjectToJson(
  NominatimSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'contains': instance.contains,
  'selectedPlaceId': instance.selectedPlaceId,
  'selectedPlaceType': instance.selectedPlaceType,
};
