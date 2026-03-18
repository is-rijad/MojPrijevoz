import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
part 'fare_offer_response.g.dart';

@JsonSerializable()
class FareOfferResponse extends JsonResponse {
  @override
  final int id;
  final FareOfferSide side;
  final double price;
  final DateTime createdAt;
  final int fareId;
  final int? lastOfferId;
  final FareResponse? fare;
  FareOfferResponse({
    required this.id,
    required this.side,
    required this.price,
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
