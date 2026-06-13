// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_offer_update_request.g.dart';

@JsonSerializable(explicitToJson: true)
class FareOfferUpdateRequest extends JsonRequest {
  double? price;
  double? additionalPrice;

  FareOfferUpdateRequest({this.price, this.additionalPrice});

  @override
  Map<String, dynamic> toJson() => _$FareOfferUpdateRequestToJson(this);

  factory FareOfferUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$FareOfferUpdateRequestFromJson(json);
}
