// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_create_intent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeCreateIntentResponse _$StripeCreateIntentResponseFromJson(
  Map<String, dynamic> json,
) => StripeCreateIntentResponse(
  id: (json['id'] as num).toInt(),
  clientSecret: json['clientSecret'] as String,
);

Map<String, dynamic> _$StripeCreateIntentResponseToJson(
  StripeCreateIntentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientSecret': instance.clientSecret,
};
