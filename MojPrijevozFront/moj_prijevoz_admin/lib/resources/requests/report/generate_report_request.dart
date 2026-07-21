import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/reports/report_period.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/reports/report_type.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
part 'generate_report_request.g.dart';

@JsonSerializable()
class GenerateReportRequest extends JsonParsable {
  ReportType? type;
  ReportPeriod? period;
  DateTime? from;
  DateTime? to;

  GenerateReportRequest({this.type, this.period});
  factory GenerateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateReportRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenerateReportRequestToJson(this);
}
