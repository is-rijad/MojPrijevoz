import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'drivers_discount_search_object.g.dart';

@JsonSerializable()
class DriversDiscountSearchObject extends BaseSearchObject {
  DriversDiscountSearchObject({required super.page, required super.pageSize});
  @override
  Map<String, dynamic> toJson() => _$DriversDiscountSearchObjectToJson(this);
  factory DriversDiscountSearchObject.fromJson(Map<String, dynamic> json) =>
      _$DriversDiscountSearchObjectFromJson(json);
}
