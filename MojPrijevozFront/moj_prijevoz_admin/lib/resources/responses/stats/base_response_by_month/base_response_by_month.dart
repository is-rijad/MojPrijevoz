// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'base_response_by_month.g.dart';

@JsonSerializable()
class BaseResponseByMonth extends JsonResponse {
  @override
  int get id => -1;
  int month;
  int year;
  double result;

  BaseResponseByMonth({
    required this.month,
    required this.year,
    required this.result,
  });

  factory BaseResponseByMonth.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseByMonthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseResponseByMonthToJson(this);
}
