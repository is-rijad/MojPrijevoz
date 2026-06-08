import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'rating_insert_request.g.dart';

@JsonSerializable()
class RatingInsertRequest extends JsonRequest {
  final int? fareId;
  final String? comment;
  final int? grade;
  final ProfileType? profileType;

  RatingInsertRequest({
    this.fareId,
    this.comment,
    this.grade,
    this.profileType,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareRequestToJson(this);

  factory RatingInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchFareRequestFromJson(json);
}
