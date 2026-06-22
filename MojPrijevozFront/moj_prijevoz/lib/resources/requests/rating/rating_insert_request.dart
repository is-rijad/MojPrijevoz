import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/profile_type.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'rating_insert_request.g.dart';

@JsonSerializable()
class RatingInsertRequest extends JsonRequest {
  int? fareId;
  String? comment;
  int? grade;
  ProfileType? profileType;

  RatingInsertRequest({
    this.fareId,
    this.comment,
    this.grade,
    this.profileType,
  });

  @override
  Map<String, dynamic> toJson() => _$RatingInsertRequestToJson(this);

  factory RatingInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingInsertRequestFromJson(json);
}
