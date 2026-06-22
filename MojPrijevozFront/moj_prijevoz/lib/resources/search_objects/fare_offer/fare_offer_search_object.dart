import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/search_objects/base_search_object.dart';

part 'fare_offer_search_object.g.dart';

@JsonSerializable()
class FareOfferSearchObject extends BaseSearchObject {
  FareOfferSearchObject({required super.page, required super.pageSize});

  @override
  Map<String, dynamic> toJson() => _$FareOfferSearchObjectToJson(this);

  factory FareOfferSearchObject.fromJson(Map<String, dynamic> json) =>
      _$FareOfferSearchObjectFromJson(json);
}
