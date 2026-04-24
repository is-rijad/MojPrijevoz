import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'stripe_create_intent_request.g.dart';

@JsonSerializable()
class StripeCreateIntentRequest extends JsonRequest {
  final int fareOfferId;

  StripeCreateIntentRequest({required this.fareOfferId});

  @override
  Map<String, dynamic> toJson() => _$StripeCreateIntentRequestToJson(this);

  factory StripeCreateIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$StripeCreateIntentRequestFromJson(json);
}
