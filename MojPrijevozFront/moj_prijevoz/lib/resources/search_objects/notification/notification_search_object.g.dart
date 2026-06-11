// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSearchObject _$NotificationSearchObjectFromJson(
  Map<String, dynamic> json,
) => NotificationSearchObject(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$NotificationSearchObjectToJson(
  NotificationSearchObject instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};
