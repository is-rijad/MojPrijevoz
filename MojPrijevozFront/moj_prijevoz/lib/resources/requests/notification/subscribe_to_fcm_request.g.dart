// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_to_fcm_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeToFcmRequest _$SubscribeToFcmRequestFromJson(
  Map<String, dynamic> json,
) => SubscribeToFcmRequest(
  token: json['token'] as String?,
  platform: json['platform'] as String?,
);

Map<String, dynamic> _$SubscribeToFcmRequestToJson(
  SubscribeToFcmRequest instance,
) => <String, dynamic>{'token': instance.token, 'platform': instance.platform};
