import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'rating_update_request.g.dart';

@JsonSerializable()
class RatingUpdateRequest extends JsonRequest {
  bool? isVisible;

  RatingUpdateRequest({this.isVisible});

  factory RatingUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingUpdateRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RatingUpdateRequestToJson(this);
}
