import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/common/resources/user_for_circle_avatar_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'recommended_driver_response.g.dart';

@JsonSerializable()
class RecommendedDriverResponse extends JsonResponse
    implements UserForCircleAvatarInterface {
  @override
  int id;
  @override
  String firstName;
  @override
  String lastName;
  @override
  String? picture;

  @override
  AccountStatus status;
  final double averageRating;
  final String originCityName;
  final String destinationName;
  final int ridesCount;

  RecommendedDriverResponse({
    required this.originCityName,
    required this.destinationName,
    required this.id,
    required this.firstName,
    required this.lastName,
    this.picture,
    required this.averageRating,
    required this.ridesCount,
    required this.status,
  });

  @override
  Map<String, dynamic> toJson() => _$RecommendedDriverResponseToJson(this);

  factory RecommendedDriverResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedDriverResponseFromJson(json);
}
