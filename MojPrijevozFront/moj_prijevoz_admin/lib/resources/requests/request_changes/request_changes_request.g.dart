// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_changes_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestChangesRequest _$RequestChangesRequestFromJson(
  Map<String, dynamic> json,
) => RequestChangesRequest(
  notes: (json['notes'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  selectedItems: (json['selectedItems'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RequestChangesRequestToJson(
  RequestChangesRequest instance,
) => <String, dynamic>{
  'selectedItems': instance.selectedItems,
  'notes': instance.notes,
};
