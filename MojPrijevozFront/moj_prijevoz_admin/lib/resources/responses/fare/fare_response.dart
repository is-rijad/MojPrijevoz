import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare_data/fare_data_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_profile/user_profile_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'fare_response.g.dart';

@JsonSerializable()
class FareResponse extends JsonResponse {
  @override
  final int id;
  final int fareDataId;
  final int passengerId;
  final FareDataResponse? fareData;
  final UserProfileResponse? passenger;
  FareResponse({
    required this.id,
    required this.fareDataId,
    this.fareData,
    required this.passengerId,
    this.passenger,
  });

  factory FareResponse.fromJson(Map<String, dynamic> json) =>
      _$FareResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FareResponseToJson(this);
}
