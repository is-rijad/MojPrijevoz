// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_offer_status.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_offer_response.g.dart';

@JsonSerializable()
class FareOfferResponse extends JsonResponse {
  @override
  final int id;
  final FareOfferSide side;
  final FareOfferStatus status;
  final double price;
  final double? additionalPrice;
  final DateTime createdAt;
  final int fareId;
  final int? lastOfferId;
  final FareResponse? fare;
  double get totalPrice => price + (additionalPrice ?? 0);
  FareOfferResponse({
    required this.id,
    required this.side,
    required this.status,
    required this.price,
    this.additionalPrice,
    required this.createdAt,
    required this.fareId,
    required this.lastOfferId,
    required this.fare,
  });

  @override
  Map<String, dynamic> toJson() => _$FareOfferResponseToJson(this);

  factory FareOfferResponse.fromJson(Map<String, dynamic> json) =>
      _$FareOfferResponseFromJson(json);
}
