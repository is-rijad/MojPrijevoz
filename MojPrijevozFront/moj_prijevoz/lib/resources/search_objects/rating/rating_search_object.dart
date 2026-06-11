// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
part 'rating_search_object.g.dart';

@JsonSerializable()
class RatingSearchObject extends BaseSearchObject {
  int? profileId;
  RatingSearchObject({
    required super.page,
    required super.pageSize,
    this.profileId,
  });

  @override
  Map<String, dynamic> toJson() => _$RatingSearchObjectToJson(this);

  factory RatingSearchObject.fromJson(Map<String, dynamic> json) =>
      _$RatingSearchObjectFromJson(json);
}
