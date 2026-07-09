import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_profile/user_profile_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_ratings_response.g.dart';

@JsonSerializable()
class AllRatingsResponse extends JsonResponse {
  @override
  final int id;
  final int fromId;
  final int toId;
  final UserProfileResponse? from;
  final UserProfileResponse? to;
  final int grade;
  bool isVisible;
  final DateTime createdAt;

  AllRatingsResponse({
    required this.id,
    required this.fromId,
    required this.toId,
    this.from,
    this.to,
    required this.grade,
    required this.isVisible,
    required this.createdAt,
  });

  factory AllRatingsResponse.fromJson(Map<String, dynamic> json) =>
      _$AllRatingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllRatingsResponseToJson(this);
}
