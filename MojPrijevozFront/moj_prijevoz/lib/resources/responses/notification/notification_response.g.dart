// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => NotificationResponse(
  id: (json['id'] as num).toInt(),
  message: json['message'] as String,
  type: json['type'] as String,
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  fareId: (json['fareId'] as num?)?.toInt(),
  side: (json['side'] as num?)?.toInt(),
  ratingId: (json['ratingId'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationResponseToJson(
  NotificationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'message': instance.message,
  'type': instance.type,
  'fareId': instance.fareId,
  'side': instance.side,
  'ratingId': instance.ratingId,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};
