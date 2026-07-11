import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'users_by_city_response.g.dart';

@JsonSerializable()
class UsersByCityResponse extends JsonResponse {
  @override
  int get id => -1;
  String cityName;
  String lat;
  String long;
  int usersCount;

  UsersByCityResponse({
    required this.cityName,
    required this.lat,
    required this.long,
    required this.usersCount,
  });

  factory UsersByCityResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersByCityResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UsersByCityResponseToJson(this);
}
