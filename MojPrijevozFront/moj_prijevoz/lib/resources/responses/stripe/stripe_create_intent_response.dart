import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'stripe_create_intent_response.g.dart';

@JsonSerializable()
class StripeCreateIntentResponse extends JsonResponse {
  @override
  final int id;
  final String clientSecret;

  StripeCreateIntentResponse({required this.id, required this.clientSecret});

  @override
  Map<String, dynamic> toJson() => _$StripeCreateIntentResponseToJson(this);

  factory StripeCreateIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$StripeCreateIntentResponseFromJson(json);
}
