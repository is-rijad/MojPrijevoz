import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/fare_status.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'fares_this_month_response.g.dart';

@JsonSerializable()
class FaresThisMonthResponse extends JsonResponse {
  @override
  int get id => -1;
  final FareStatus status;
  final int count;

  FaresThisMonthResponse({required this.status, required this.count});

  factory FaresThisMonthResponse.fromJson(Map<String, dynamic> json) =>
      _$FaresThisMonthResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FaresThisMonthResponseToJson(this);
}
